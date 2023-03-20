import Capacitor
import Foundation
import UserNotifications

enum PushNotificationError: Error {
    case tokenParsingFailed
    case tokenRegistrationFailed
}

enum PushNotificationsPermissions: String {
    case prompt
    case denied
    case granted
}

@objc(Plumb5Plugin)
public class Plumb5Plugin: CAPPlugin {
    public static let sharedInstance = Plumb5Plugin()

    private let notificationDelegateHandler = P5PushNotificationsHandler()
    private var appDelegateRegistrationCalled: Bool = false
    
    private var SDKVaild  = false

    override public func load() {
        let accountId = Bundle.main.object(forInfoDictionaryKey: "accountId") as? String ?? ""
        let appKey = Bundle.main.object(forInfoDictionaryKey: "appKey") as? String ?? ""
        let serviceURL = Bundle.main.object(forInfoDictionaryKey: "serviceURL") as? String ?? ""
        P5SDKManager.sharedInstance.p5getUrl = serviceURL
        P5SDKManager.sharedInstance.p5getAppKey = appKey
        P5SDKManager.sharedInstance.cache = NSCache()

        bridge?.notificationRouter.pushNotificationHandler = notificationDelegateHandler
        notificationDelegateHandler.plugin = self
        P5SDKManager.sharedInstance.P5plugin = self

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRegisterForRemoteNotificationsWithDeviceToken(notification:)),
                                               name: .capacitorDidRegisterForRemoteNotifications,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFailToRegisterForRemoteNotificationsWithError(notification:)),
                                               name: .capacitorDidFailToRegisterForRemoteNotifications,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /**
     * Initialize SDK
     */
    @objc func initializePlumb5(_ call: CAPPluginCall) {
        let url = Constants.base_url + Constants.api_ValidatAppKeyNew
    

        P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: nil) { result, success in
            if success == true && result != nil {
                let rootObj = (JSON(result!).array ?? [])
                if rootObj.count > 0 {
                    let dict = rootObj[0].dictionaryObject
                    //                    let projectNumber = dict!["GcmProjectNo"] as? String
                    let bundleIdentfier = Bundle.main.bundleIdentifier
                    let packageName = dict!["IosPackageName"] as? String
                    if bundleIdentfier == packageName {
                        P5SDKManager.sharedInstance.p5BundleIdentifier = packageName
                        self.deviceRegistration()

             
                        call.resolve()
                        self.SDKVaild  = true
                        print("API", url, " successful")
                    } else {
                        print("Expected valid apiKey for the bundle")
                        call.reject("Expected valid apiKey for the bundle")
                    }
                } else {
                    print("API ", url, " unsuccessful")
                    call.reject("API result unsuccessful")
                }
            } else {
                print("API network unsuccessful")
                call.reject("API network unsuccessful")
            }
        }
    }
    /**
     * Send device registration
     */
    func deviceRegistration() {
        if(SDKVaild){
            return
        }
        let deviceInfo = [
            "DeviceId": P5DeviceInfo.sharedInstance.getDeviceId(),
            "Manufacturer": Constants.value_apple,
            "DeviceName": P5DeviceInfo.sharedInstance.getDeviceModel(),
            "OS": Constants.value_apple,
            "OsVersion": P5DeviceInfo.sharedInstance.getOSVersion(),
            "AppVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "CarrierName": P5DeviceInfo.sharedInstance.getCarrier(),
            "DeviceDate": Date.getCurrentDate(),
            "GcmRegId": P5SDKManager.sharedInstance.p5DeviceToken,
            "Resolution": P5DeviceInfo.sharedInstance.getResolution(),
            "InstalledStatus": true,
            "GcmSettingsId": 0,
            "IsInstalledStatusDate": Date.getCurrentDate(),

        ] as! [String: AnyObject]

        let url = Constants.base_url + Constants.api_RegisterDevice

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: deviceInfo) { result, success in
                if success == true && result != nil {
                    print((result as? String)?.description ?? "")

                    print("API", url, " successful")
                } else {
                    print("API ", url, " unsuccessful")
                }
            }
        } else {
            print("API network unsuccessful")
        }
    }
    /**
     * Send device trackig
     */
    @objc func tracking(_ call: CAPPluginCall) {
        if(SDKVaild){
            return
        }
        let datetime = P5SessionId.sharedInstance.getCurrentDate()
        let trackData = [Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
                         Constants.key_GcmRegId: P5SDKManager.sharedInstance.p5DeviceToken,
                         Constants.key_ScreenName: call.getString("ScreenName", ""),
                         Constants.key_CampaignId: "0",
                         Constants.key_NewSession: "0",
                         Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
                         Constants.key_Offline: "0",
                         Constants.key_TrackDate: datetime,
                         Constants.key_GeofenceId: "0",
                         Constants.key_Locality: P5LoactionInfo.sharedInstance.locality,
                         Constants.key_City: P5LoactionInfo.sharedInstance.city,
                         Constants.key_State: P5LoactionInfo.sharedInstance.state,
                         Constants.key_Country: P5LoactionInfo.sharedInstance.country,
                         Constants.key_CountryCode: P5LoactionInfo.sharedInstance.countryCode,
                         Constants.key_Latitude: P5LoactionInfo.sharedInstance.lat,
                         Constants.key_Longitude: P5LoactionInfo.sharedInstance.lon,
                         Constants.key_PageParameter: call.getString("PageParameter", "")]

        P5SDKManager.sharedInstance.screenName = call.getString("ScreenName", "")

        let url = Constants.base_url + Constants.api_initSession

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: trackData) { result, success in
                if success == true && result != nil {
                    print((result as? String)?.description ?? "")

                    print("API",url, " successful")
                } else {
                    print("API ", url, " unsuccessful")
                }
            }
        } else {
            print("API network unsuccessful")
        }
    }
    /**
     * Map and send event post
     */
    @objc func eventPost(_: CAPPluginCall) {
        if(SDKVaild){
            return
        }
        let datetime = P5SessionId.sharedInstance.getCurrentDate()

        let eventData = [Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
                         Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
                         Constants.key_Offline: "0",
                         Constants.key_TrackDate: datetime]

        let url = Constants.base_url + Constants.api_EventResponses

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: eventData) { result, success in
                if success == true && result != nil {
                    print((result as? String)?.description ?? "")

                    print("API",url, " successful")
                } else {
                    print("API ", url, " unsuccessful")
                }
            }
        } else {
            print("API network unsuccessful")
        }
    }
    /**
     * Send User Details
     */
    @objc func setUserDetails(_ call: CAPPluginCall) {
        if(SDKVaild){
            return
        }
        let param = [
            "DeviceId": P5DeviceInfo.sharedInstance.getDeviceId(),
            "Name": call.getString("Name", ""),
            "EmailId": call.getString("EmailId", ""),
            "PhoneNumber": call.getString("PhoneNumber", ""),
            "LeadType": 1,
            "Gender": call.getString("Gender", ""),
            "Age": call.getString("Age", ""),
            "AgeRange": call.getString("AgeRange", ""),
            "MaritalStatus": call.getString("MaritalStatus", ""),
            "Education": call.getString("Education", ""),
            "Occupation": call.getString("Occupation", ""),
            "Interests": call.getString("Interests", ""),
            "Location": call.getString("Location", ""),
        ] as [String: Any]

        let url = Constants.base_url + Constants.api_RegisterUser

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: param) { result, success in
                if success == true && result != nil {
                    print((result as? String)?.description ?? "")

                    print("API",url, " successful")
                } else {
                    print("API ", url, " unsuccessful")
                }
            }
        } else {
            print("API network unsuccessful")
        }
    }
    /**
     * Send push response
     */
    @objc func pushResponse(_ call: CAPPluginCall) {
        if(SDKVaild){
            return
        }
        let param = [
            Constants.key_FieldType: "1",
            Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
            Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
            Constants.key_ScreenName: call.getString("ScreenName", ""),
            Constants.key_EventId: "",
            Constants.key_EventValue: "",
            Constants.key_PageParameter: call.getString("PageParameter", ""),
        ]

        let url = Constants.base_url + Constants.api_GetField

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: param) { result, success in
                if success == true && result != nil {
                    let response = result as! NSDictionary
//                    let array = result as? Array<Any>
                    P5SDKManager.sharedInstance.processGetFieldData(array: response, screenName: call.getString("ScreenName", ""))
                    print("API",url, " successful")
                } else {
                    print("API ", url, " unsuccessful")
                }
            }
        } else {
            print("API network unsuccessful")
        }
    }

    /**
     * Send  screen route trigger
     */
    public func sendScreen(json: String) {
        bridge?.triggerWindowJSEvent(eventName: "onPushNotification", data: json)
    }

    /**
     * Register for push notifications
     */
    @objc func register(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        call.resolve()
    }

    /**
     * Request notification permission
     */
    @objc override public func requestPermissions(_ call: CAPPluginCall) {
        notificationDelegateHandler.requestPermissions { granted, error in
            guard error == nil else {
                if let err = error {
                    call.reject(err.localizedDescription)
                    return
                }

                call.reject("unknown error in permissions request")
                return
            }

            var result: PushNotificationsPermissions = .denied

            if granted {
                result = .granted
            }

            call.resolve(["receive": result.rawValue])
        }
    }

    /**
     * Check notification permission
     */
    @objc override public func checkPermissions(_ call: CAPPluginCall) {
        notificationDelegateHandler.checkPermissions { status in
            var result: PushNotificationsPermissions = .prompt

            switch status {
            case .notDetermined:
                result = .prompt
            case .denied:
                result = .denied
            case .ephemeral, .authorized, .provisional:
                result = .granted
            @unknown default:
                result = .prompt
            }

            call.resolve(["receive": result.rawValue])
        }
    }

    /**
     * Get notifications in Notification Center
     */
    @objc func getDeliveredNotifications(_ call: CAPPluginCall) {
        if !appDelegateRegistrationCalled {
            call.reject("event capacitorDidRegisterForRemoteNotifications not called.  Visit https://capacitorjs.com/docs/apis/push-notifications for more information")
            return
        }
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { notifications in
            let ret = notifications.map { notification -> [String: Any] in
                self.notificationDelegateHandler.makeNotificationRequestJSObject(notification.request)
            }
            call.resolve([
                "notifications": ret,
            ])
        })
    }

    /**
     * Remove specified notifications from Notification Center
     */
    @objc func removeDeliveredNotifications(_ call: CAPPluginCall) {
        if !appDelegateRegistrationCalled {
            call.reject("event capacitorDidRegisterForRemoteNotifications not called.  Visit https://capacitorjs.com/docs/apis/push-notifications for more information")
            return
        }
        guard let notifications = call.getArray("notifications", JSObject.self) else {
            call.reject("Must supply notifications to remove")
            return
        }

        let ids = notifications.map { $0["id"] as? String ?? "" }
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
        call.resolve()
    }

    /**
     * Remove all notifications from Notification Center
     */
    @objc func removeAllDeliveredNotifications(_ call: CAPPluginCall) {
        if !appDelegateRegistrationCalled {
            call.reject("event capacitorDidRegisterForRemoteNotifications not called.  Visit https://capacitorjs.com/docs/apis/push-notifications for more information")
            return
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        call.resolve()
    }

    @objc func createChannel(_ call: CAPPluginCall) {
        call.unimplemented("Not available on iOS")
    }

    @objc func deleteChannel(_ call: CAPPluginCall) {
        call.unimplemented("Not available on iOS")
    }

    @objc func listChannels(_ call: CAPPluginCall) {
        call.unimplemented("Not available on iOS")
    }

    @objc public func didRegisterForRemoteNotificationsWithDeviceToken(notification: NSNotification) {
        appDelegateRegistrationCalled = true
        if let deviceToken = notification.object as? Data {
            let deviceTokenString = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
            P5SDKManager.sharedInstance.p5DeviceToken = deviceTokenString
            deviceRegistration()
            notifyListeners("registration", data: [
                "value": deviceTokenString,
            ])
        } else if let stringToken = notification.object as? String {
            P5SDKManager.sharedInstance.p5DeviceToken = stringToken
            deviceRegistration()
            notifyListeners("registration", data: [
                "value": stringToken,
            ])
        } else {
            notifyListeners("registrationError", data: [
                "error": PushNotificationError.tokenParsingFailed.localizedDescription,
            ])
        }
    }

    @objc public func didFailToRegisterForRemoteNotificationsWithError(notification: NSNotification) {
        appDelegateRegistrationCalled = true
        guard let error = notification.object as? Error else {
            return
        }
        notifyListeners("registrationError", data: [
            "error": error.localizedDescription,
        ])
    }
}
