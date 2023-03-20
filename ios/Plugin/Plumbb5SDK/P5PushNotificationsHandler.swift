import Capacitor
import UserNotifications

public class P5PushNotificationsHandler: NSObject, NotificationHandlerProtocol {
    public weak var plugin: CAPPlugin?
    var notificationRequestLookup = [String: JSObject]()

    public func requestPermissions(with completion: ((Bool, Error?) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion?(granted, error)
        }
    }

    public func checkPermissions(with completion: ((UNAuthorizationStatus) -> Void)? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion?(settings.authorizationStatus)
        }
    }

    public func willPresent(notification: UNNotification) -> UNNotificationPresentationOptions {
        let userInf = JSTypes.coerceDictionaryToJSObject(notification.request.content.userInfo) ?? [:]

        let notificationData = makeNotificationRequestJSObject(notification.request)
        plugin?.notifyListeners("pushNotificationReceived", data: notificationData)

        return proccessData(data: userInf, notification: notification)
    }

    public func didReceive(response: UNNotificationResponse) {
        var data = JSObject()

        let originalNotificationRequest = response.notification.request
        let actionId: String = response.actionIdentifier

        let title: String = response.notification.request.content.userInfo["title"] as! String
        let click_action: String = response.notification.request.content.categoryIdentifier
        let click_action_data: String = response.notification.request.content.userInfo["clickaction"] as! String
        if click_action == Constants.key_pushidentifier {
            let actionParm: [String] = actionId.components(separatedBy: "^")
            if actionParm.count > 0 {
                if actionParm[0] == "btn" {
                    pushData(type: "click", btnName: "", P5UniqueId: response.notification.request.content.userInfo["P5UniqueId"] as! String, WorkFlowDataId: response.notification.request.content.userInfo["workflowdataId"] as! String)
                    if actionParm[1] == "0" || actionParm[1] == "1" {
                        // screenRoute
                        let json = "{" + "\"routeUrl\":" + "\"" + actionParm[2] + "\"" + "}"
                        plugin?.bridge?.triggerWindowJSEvent(eventName: "onPushNotification", data: json)
                    }

                    if actionParm[1] == "3" {
                        // url
                        let redirectUrl: String = actionParm[2]
                        guard let url = URL(string: redirectUrl)
                        else {
                            return
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }

        if actionId == UNNotificationDefaultActionIdentifier {
            data["actionId"] = "tap"
            pushData(type: "click", btnName: "", P5UniqueId: response.notification.request.content.userInfo["P5UniqueId"] as! String, WorkFlowDataId: response.notification.request.content.userInfo["workflowdataId"] as! String)

            if click_action == Constants.key_pushidentifier {
                let Atitle: String = title.replacingOccurrences(of: "~A~", with: "&")
                let actionParm: [String] = Atitle.components(separatedBy: "^")
                if actionParm.count > 0 {
                    if click_action_data == "0" {
                        // screenRoute
                        let json = "{" + "\"routeUrl\":" + "\"" + actionParm[4] + "\"" + "}"
                        plugin?.bridge?.triggerWindowJSEvent(eventName: "onPushNotification", data: json)
                    }

                    if click_action_data == "2" {
                        // url
                        let redirectUrl: String = actionParm[4]
                        guard let url = URL(string: redirectUrl)
                        else {
                            return
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }

        } else if actionId == UNNotificationDismissActionIdentifier {
            pushData(type: "close", btnName: "", P5UniqueId: response.notification.request.content.userInfo["P5UniqueId"] as! String, WorkFlowDataId: response.notification.request.content.userInfo["workflowdataId"] as! String)
            data["actionId"] = "dismiss"
        } else {
            data["actionId"] = actionId
        }

        if let inputType = response as? UNTextInputNotificationResponse {
            data["inputValue"] = inputType.userText
        }

        data["notification"] = makeNotificationRequestJSObject(originalNotificationRequest)

        plugin?.notifyListeners("pushNotificationActionPerformed", data: data, retainUntilConsumed: true)
    }

    func makeNotificationRequestJSObject(_ request: UNNotificationRequest) -> JSObject {
        return [
            "id": request.identifier,
            "title": request.content.title,
            "subtitle": request.content.subtitle,
            "badge": request.content.badge ?? 1,
            "body": request.content.body,
            "data": JSTypes.coerceDictionaryToJSObject(request.content.userInfo) ?? [:],
        ]
    }

    func proccessData(data _: [String: Any], notification: UNNotification) -> UNNotificationPresentationOptions {


        if let options = notificationRequestLookup[notification.request.identifier] {
            let silent = options["silent"] as? Bool ?? false

            if silent {
                return UNNotificationPresentationOptions(rawValue: 0)
            }
        }
        var presentationOptions = UNNotificationPresentationOptions()

        if #available(iOS 14.0, *) {
            presentationOptions.insert(.list)

            presentationOptions.insert(.banner)

            presentationOptions.insert(.badge)

            presentationOptions.insert(.sound)

        } else {
            presentationOptions.insert(.alert)

            presentationOptions.insert(.badge)

            presentationOptions.insert(.sound)
        }

        return presentationOptions
    }

    func registerPushNotificationCategories(categories: [PushNotificationCategory]?, completionHandler: @escaping (Bool) -> Void) {
        guard let categories = categories else {
            if #available(iOS 10.0, *) {
                let notificationCategories = Set<UNNotificationCategory>()
                UNUserNotificationCenter.current().setNotificationCategories(notificationCategories)
            } else {
                // Fallback on earlier versions
            }
            return
        }
        if #available(iOS 10.0, *) {
            var notificationCategories = Set<UNNotificationCategory>()
            for category in categories {
                var actionList = [UNNotificationAction]()
                for action in category.pushActions! {
                    let action = UNNotificationAction(identifier: action.identifier!, title: action.button_title!, options: [])
                    actionList.append(action)
                }
                let category = UNNotificationCategory(identifier: category.name!, actions: actionList, intentIdentifiers: [], options: [])
                notificationCategories.insert(category)
            }
            UNUserNotificationCenter.current().setNotificationCategories(notificationCategories)
            UNUserNotificationCenter.current().getNotificationCategories(completionHandler: { _ in
                completionHandler(true)
            })
        } else {}
    }

    // Helper function inserted by Swift 4.2 migrator.
    public func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value) })
    }
    
    /**
     * Send click action
     */

    public func pushData(type: String, btnName: String, P5UniqueId: String, WorkFlowDataId: String) {
        var params: [String: Any] = Dictionary()

        params.updateValue(WorkFlowDataId, forKey: Constants.key_WorkFlowDataId)
        params.updateValue("Push", forKey: Constants.key_FormResponses)
        params.updateValue("0", forKey: "MobileFormId")

        params.updateValue(type == "view" ? 1 : 0, forKey: Constants.key_BannerView)
        params.updateValue(type == "click" ? 1 : 0, forKey: Constants.key_BannerClick)
        params.updateValue(type == "close" ? 1 : 0, forKey: Constants.key_BannerClose)

        params.updateValue(btnName, forKey: Constants.key_ButtonName)

        params.updateValue(P5SessionId.sharedInstance.getSessionId(), forKey: Constants.key_SessionId)
        params.updateValue(P5DeviceInfo.sharedInstance.getDeviceId(), forKey: Constants.key_DeviceId)
        params.updateValue("0", forKey: "SendReport")
        params.updateValue("", forKey: "WidgetName")
        params.updateValue(P5UniqueId, forKey: "P5UniqueId")

        params.updateValue(P5SDKManager.sharedInstance.screenName, forKey: "ScreenName")

        params.updateValue("", forKey: "BeaconName")

        params.updateValue("", forKey: "GeofenceName")
        print("params = %@", params)
        let url = Constants.base_url + Constants.api_formResponses
        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: params) { result, success in
                if success == true && result != nil {
                    print("success " + url + "result = " + (result as? String ?? ""))
                } else {
                    print("Error")
                }
            }
        } else {
            print("No Network")
        }
    }
    
    /**
     * Send formData click action
     */

    public func fromeData(type: String, MobileFormId: String, WidgetName: String, btnName: String? = "", WorkFlowDataId: String, FormResponses: String? = "Widget") {
        var params: [String: Any] = Dictionary()

        params.updateValue(Int(MobileFormId) ?? 0, forKey: "MobileFormId")
        params.updateValue(WorkFlowDataId, forKey: Constants.key_WorkFlowDataId)
        params.updateValue(FormResponses!, forKey: Constants.key_FormResponses)

        params.updateValue(type == "view" ? 1 : 0, forKey: Constants.key_BannerView)
        params.updateValue(type == "click" ? 1 : 0, forKey: Constants.key_BannerClick)
        params.updateValue(type == "close" ? 1 : 0, forKey: Constants.key_BannerClose)

        params.updateValue(btnName!, forKey: Constants.key_ButtonName)

        params.updateValue(P5SessionId.sharedInstance.getSessionId(), forKey: Constants.key_SessionId)
        params.updateValue(P5DeviceInfo.sharedInstance.getDeviceId(), forKey: Constants.key_DeviceId)
        params.updateValue("0", forKey: "SendReport")
        params.updateValue(WidgetName, forKey: "WidgetName")

        params.updateValue(P5SDKManager.sharedInstance.screenName, forKey: "ScreenName")

        params.updateValue("", forKey: "BeaconName")

        params.updateValue("", forKey: "GeofenceName")
        params.updateValue("", forKey: "P5UniqueId")
        print("params = %@", params)
        let url = Constants.base_url + Constants.api_formResponses
        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: params) { result, success in
                if success == true && result != nil {
                    print("success " + url + "result = " + (result as? String ?? ""))
                } else {
                    print("Error")
                }
            }
        } else {
            print("No Network")
        }
    }
    /**
     * Send click information
     */
    public func pushData(type: String, P5UniqueId: String, MobileFormId _: String, WidgetName: String, btnName: String? = "") {
        var params: [String: Any] = Dictionary()

        params.updateValue("", forKey: Constants.key_WorkFlowDataId)
        params.updateValue("Push", forKey: Constants.key_FormResponses)

        params.updateValue(type == "view" ? "1" : "0", forKey: Constants.key_BannerView)
        params.updateValue(type == "click" ? "1" : "0", forKey: Constants.key_BannerClick)
        params.updateValue(type == "close" ? "1" : "0", forKey: Constants.key_BannerClose)

        params.updateValue(btnName, forKey: Constants.key_ButtonName)

        params.updateValue(P5SessionId.sharedInstance.getSessionId(), forKey: Constants.key_SessionId)
        params.updateValue(P5DeviceInfo.sharedInstance.getDeviceId(), forKey: Constants.key_DeviceId)
        params.updateValue("0", forKey: "SendReport")
        params.updateValue(WidgetName, forKey: "WidgetName")

        params.updateValue(P5SDKManager.sharedInstance.screenName, forKey: "ScreenName")

        params.updateValue("", forKey: "BeaconName")

        params.updateValue("", forKey: "GeofenceName")
        params.updateValue(P5UniqueId, forKey: "P5UniqueId")
        print("params = %@", params)
        let url = Constants.base_url + Constants.api_formResponses
        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: params) { result, success in
                if success == true && result != nil {
                    print("success " + url + "result = " + (result as? String ?? ""))
                } else {
                    print("Error")
                }
            }
        } else {
            print("No Network")
        }
    }

    public func showToast(message: String) {
        if message.count == 0 {
            return
        }

        if let view = UIApplication.shared.currentWindow {
            let toastLabel = UILabel(frame: CGRect(x: 30, y: view.frame.size.height - 60, width: view.frame.size.width - 60, height: 40))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center
            toastLabel.font = .systemFont(ofSize: 12.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
            view.addSubview(toastLabel)
        } // do whatever you want with window
    }
}

extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
}

struct PushNotificationCategory {
    var name: String?
    var pushActions: [PushNotificationAction]?

    init(name: String?, pushAction: [PushNotificationAction]?) {
        self.name = name
        pushActions = pushAction
    }
}

struct PushNotificationAction: Codable {
    var button_title: String?
    var identifier: String?

    init(button_title: String?, identifier: String?) {
        self.button_title = button_title
        self.identifier = identifier
    }
}
