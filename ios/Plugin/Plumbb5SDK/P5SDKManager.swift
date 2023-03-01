//
//  P5SDKManager.swift
//  Plumb5SDK
//
//  Created by Shama on 5/1/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import CoreLocation
import MessageUI
import UIKit


import UserNotifications

public enum Actions : String{
    case Form = "Form"
    case Dismiss = "Cancel"
    case RedirectToScreen = "Screen"
    case DeepLinkingURL = "Deeplink"
    case ExternalURL = "Browser"
    case Copy = "Copy"
    case Call = "Call"
    case Share = "Share"
    case RemindLater = "Reminder"
    case EventTracking = "Event"
    case TextMessage = "Sms"
    case Permission = "Permission"
    case None = "0"
}
public protocol P5ActionsDelegate{
    func handleActionWithType(type : Actions, userInfo : Dictionary<String, Any>);
}
public class P5SDKManager : P5LocationDelegate {
    public static let BUTTON_CLICK = "BUTTON_CLICK"
    public static let sharedInstance = P5SDKManager()
    public var isPushingOfflineDataIsInProgress : Bool = false
    public var currentVC : UIViewController?
    public var delegate : P5ActionsDelegate?
    
    var geofenceRegionDate : Dictionary <String, Any>?
    var beaconRegionDate : Dictionary <String, Any>?
    var deviceTokenUpdated = false;
    
    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    private init() {
        print("P5SDKManager has been initialized")
    }
    public var p5DeviceToken = ""
    {
        didSet{
            
            deviceTokenUpdated = true
            registerDevice()
            deviceTokenUpdated = false
        }
    }
    var p5getAppKey=""
    var p5getUrl=""
    var p5Version = ""
    var cache:NSCache<AnyObject, AnyObject>!
//    var p5ProjectNumber : String?
    var p5BundleIdentifier : String?
    var inappQueue :String = ""
    var bannerQueue :String = ""
    var bannerView :UIView?
    var bannerDelegate :P5BannerDelegate?
    
    func pushOfflineDataToServer()  {
//        if P5SDKManager.sharedInstance.isPushingOfflineDataIsInProgress == false {
//            let screenList = P5DBStoreManager.sharedInstance.listOfScreenFlowObject()
//            if screenList.count > 0 {
//                P5SDKManager.sharedInstance.isPushingOfflineDataIsInProgress = true
//                self.pushOfflineInitDataToServer(screenList: screenList)
//            }
//        }
//        self.pushOfflineUserDataInToServer()
    }
    
//    func pushOfflineInitDataToServer(screenList : [ScreenFlow]  ){
//        
//        
//        var trackDataArray = [Any]()
//        for item in screenList {
//            let trackData  = self.getTrackData(screenName:item.screenName! , extraParam: item.extraParam!, offline: item.offline!,dateTime:  item.dateTime!, sessionId: item.sessionId!)
//            trackDataArray.append(trackData)
//        }
//        
//        let param = [Constants.key_appkey: p5getAppKey,
//                     Constants.key_carriername: P5DeviceInfo.sharedInstance.getCarrier(),
//                     Constants.key_TrackData:trackDataArray] as [String : Any]
//        
//        let url = Constants.base_url + Constants.api_initSession
//        
//        if checkNetworkRecheablity() {
//            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: param) { (result, success) in
//                if success == true && result != nil {
//                    if P5SDKManager.sharedInstance.inappQueue.count > 0{
//                        P5SDKManager.showInAppBannerDialog(screenName: P5SDKManager.sharedInstance.inappQueue)
//                    }
//                    if P5SDKManager.sharedInstance.bannerQueue.count > 0{
//                        P5SDKManager.loadBanner(screenName:  P5SDKManager.sharedInstance.bannerQueue, bannerView:  P5SDKManager.sharedInstance.bannerView!, delegate:  P5SDKManager.sharedInstance.bannerDelegate!)
//                    }
//                    for item in screenList {
//                        P5DBStoreManager.sharedInstance.removeScreenDetailsFromDB(item: item)
//                    }
//                }
//                else {
//                    print("Error")
//                }
//                P5SDKManager.sharedInstance.isPushingOfflineDataIsInProgress = false
//            }
//        }else{
//            //Offline
//            P5SDKManager.sharedInstance.isPushingOfflineDataIsInProgress = false
//        }
//        
//        
//    }
    
    func pushOfflineUserDataInToServer()  {
//        let userList = P5DBStoreManager.sharedInstance.listOfUserDetailsObject()
//
//        for item in userList {
//
//            let param = [Constants.key_appkey: p5getAppKey,
//                         Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
//                         Constants.key_name:item.name,
//                         Constants.key_EmailId:item.email,Constants.key_PhoneNumber:item.phone,
//                         Constants.key_ExtraParam:""]
//
//            let url = Constants.base_url + Constants.api_RegisterUser
//
//            if checkNetworkRecheablity() {
//                P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: param) { (result, success) in
//                    if success == true && result != nil {
//                        P5DBStoreManager.sharedInstance.removeUserDetailsFromDB(item: item)
//                    }
//                    else {
//                        print("Error")
//                    }
//                }
//            }else{
//                //Offline
//            }
//        }
    }
    
    func getTrackData(screenName :String,extraParam:String, offline: String, dateTime: String, sessionId: String) -> Dictionary<String, String> {
        let datetime = dateTime.isEmpty  ? P5SessionId.sharedInstance.getCurrentDate() : dateTime
        let trackData = [Constants.key_SessionId: sessionId,
                         Constants.key_GcmRegId:"",
                         Constants.key_ScreenName:screenName,
                         Constants.key_CampaignId:"0",
                         Constants.key_NewSession:"0",
                         Constants.key_DeviceId:P5DeviceInfo.sharedInstance.getDeviceId(),
                         Constants.key_Offline:offline,
                         Constants.key_TrackDate:datetime,
                         Constants.key_GeofenceId:"0",
                         Constants.key_Locality:P5LoactionInfo.sharedInstance.locality,
                         Constants.key_City:P5LoactionInfo.sharedInstance.city,
                         Constants.key_State:P5LoactionInfo.sharedInstance.state,
                         Constants.key_Country:P5LoactionInfo.sharedInstance.country,
                         Constants.key_CountryCode:P5LoactionInfo.sharedInstance.countryCode,
                         Constants.key_Latitude:P5LoactionInfo.sharedInstance.lat,
                         Constants.key_Longitude:P5LoactionInfo.sharedInstance.lon,
                         Constants.key_PageParameter:extraParam];
        
        return trackData
    }
    
    func updateLocation() {
        self.pushOfflineDataToServer();
    }
    
    public func checkNetworkRecheablity() -> Bool{
        let reachability = Reachability()!
        
        
        if reachability.connection != .none {
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                return true
            } else {
                print("Reachable via Cellular")
                return true
            }
        } else {
            print("Network not reachable")
            return false
        }
    }
    
    
    
    public func registerDevice()   {
        
        
        if checkIfDeviceInfoNeedsToBeUpdated() {
            let deviceInfo = P5DeviceInfo.sharedInstance.getDeviceInfoAsJson()
            
            let populatedDictionary = [Constants.key_appkey: p5getAppKey, Constants.key_GcmRegId: P5SDKManager.sharedInstance.p5DeviceToken,Constants.key_deviceinfo:deviceInfo] as [String : Any]
            let url = Constants.base_url + Constants.api_RegisterDevice
            
            if (checkNetworkRecheablity()) {
                P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: populatedDictionary) { (result, success) in
                    if success == true && result != nil {
                        print((result as? String)?.description ?? "")
                        self.saveDeviceInfoStatusInDB()
                    }
                    else {
                        print("Error")
                    }
                }
            }else{
                //Offline
            }
        }
    }
    
    func saveDeviceInfoStatusInDB()   {
        UserDefaults.standard.setValue(P5DeviceInfo.sharedInstance.getOSVersion(), forKey: Constants.key_osversion)
        UserDefaults.standard.setValue(P5DeviceInfo.sharedInstance.getCarrier(), forKey: Constants.key_carriername)
        UserDefaults.standard.setValue(p5Version, forKey: Constants.key_appversion)
        UserDefaults.standard.setValue(P5DeviceInfo.sharedInstance.getResolution(), forKey: Constants.key_resolution)
        
    }
    
    func checkIfDeviceInfoNeedsToBeUpdated() -> Bool {
        
        let storedOSVersion = UserDefaults.standard.string(forKey: Constants.key_osversion)
        let latestOSVersion = P5DeviceInfo.sharedInstance.getOSVersion()
        UserDefaults.standard.set(latestOSVersion, forKey: Constants.key_osversion)
        if storedOSVersion == nil || storedOSVersion != latestOSVersion {
            return true
        }
        
        let storedCareer = UserDefaults.standard.string(forKey: Constants.key_carriername)
        let latestCareer = P5DeviceInfo.sharedInstance.getCarrier()
        UserDefaults.standard.set(latestCareer, forKey: Constants.key_carriername)
        
        if storedCareer == nil || storedCareer != latestCareer {
            return true
        }
        
        let storedAppVersion = UserDefaults.standard.string(forKey: Constants.key_appversion)
        let latestAppVersion = p5Version
        UserDefaults.standard.set(latestAppVersion, forKey: Constants.key_appversion)
        if storedAppVersion == nil || storedAppVersion != latestAppVersion {
            return true
        }
        
        
        let storedResolution = UserDefaults.standard.string(forKey: Constants.key_resolution)
        let latestResolution = P5DeviceInfo.sharedInstance.getResolution()
        UserDefaults.standard.set(latestResolution, forKey: Constants.key_resolution)
        if storedResolution == nil || storedResolution != latestResolution {
            return true
        }
        if deviceTokenUpdated {
            return true
        }
        
        return false
    }
    
    public func registerUser(name: String,email: String,phoneNumber: String,extraParam: String){
        let param = [Constants.key_appkey: p5getAppKey,
                     Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
                     Constants.key_name:name,
                     Constants.key_EmailId:email,Constants.key_PhoneNumber:phoneNumber,
                     Constants.key_ExtraParam:extraParam]
        
        let url = Constants.base_url + Constants.api_RegisterUser
        
        if checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: param) { (result, success) in
                if success == true && result != nil {
                    
                }
                else {
                    print("Error")
                }
            }
        }
    }
    
    public func initSession(screenName: String, paramDict:String ){
        if checkNetworkRecheablity() {
            
//            P5DBStoreManager.sharedInstance.screenFlowAdd(screenName: screenName, extraParam: paramDict,dateTime: P5SessionId.sharedInstance.getCurrentDate(),sessionId: P5SessionId.sharedInstance.getSessionId(),offlineMode: Constants.value_onlineMode)

            
            if P5LoactionInfo.sharedInstance.isLocationUpdated == false {
                P5LoactionInfo.sharedInstance.delegate = self
                P5LoactionInfo.sharedInstance.determineMyCurrentLocation()
                
            }else{
                self.updateLocation()
            }
            
        }else{
//            P5DBStoreManager.sharedInstance.screenFlowAdd(screenName: screenName, extraParam: paramDict,dateTime: P5SessionId.sharedInstance.getCurrentDate(),sessionId: P5SessionId.sharedInstance.getSessionId(),offlineMode: Constants.value_offlineMode)
        }
    }
    public class func getDeviceInfoAsJson() -> [String:String]{
         print(P5DeviceInfo.sharedInstance.getDeviceInfoAsJson())
        
        return P5DeviceInfo.sharedInstance.getDeviceInfoAsJson()
        
     }
    func getAllBeacons(){
//        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
//            print("Invalid Packagename")
//        }else{
//            let url = Constants.base_url + Constants.api_GetBeaconRequest + "?" + Constants.key_appkey + "=" + p5getAppKey
//
//            if checkNetworkRecheablity() {
//                P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: nil) { (result, success) in
//                    if success == true && result != nil {
//                        let array = result as? Array<Any>
//                        if array != nil {
//                            P5BlueToothManager.sharedInstance.startMonitoringRegions(regions: array! )
//                        }
//                    }
//                    else {
//                        print("Error")
//                    }
//                }
//            }else{
//                print("No Network");
//            }
//
//        }
    }
    func getAllGeoFenceData(){
//        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
//            print("Invalid Packagename")
//        }else{
//            let url = Constants.base_url + Constants.api_GetPushRequest + "?" + Constants.key_appkey + "=" + p5getAppKey
//
//            if checkNetworkRecheablity() {
//                P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: nil) { (result, success) in
//                    if success == true && result != nil {
////                        let array = result as? Array<Any>
//                        let regions : Array<Dictionary<String, Any>> = result as! Array<Dictionary<String, Any>>
//                        var processedRegions : Array<Dictionary<String, Any>> = Array<Dictionary<String, Any>>()
//                        for region in regions{
//                            let MobilePushId = region["MobilePushId"] as? NSNumber
//                            let Latitude = region["Latitude"] as? String
//                            let Longitude = region["Longitude"] as? String
//                            let Radius = region["Radius"] as? String
//                            let EntryExist = region["EntryExist"] as? NSNumber
//                            let GeofenceName = region["GeofenceName"] as? String
//                            var dict : Dictionary<String, Any>  = Dictionary<String, Any>()
//                            dict["MobilePushId"] = (MobilePushId?.stringValue)!
//                            dict["Latitude"] = Latitude
//                            dict["Longitude"] = Longitude
//                            dict["Radius"] = Radius
//                            dict["EntryExist"] = (EntryExist?.stringValue)!
//                            dict["GeofenceName"] = GeofenceName
//                            processedRegions.append(dict)
//                        }
//                        if processedRegions != nil {
//                            P5LoactionInfo.sharedInstance.startMonitoringRegions(regions:processedRegions)
//                        }
//                    }
//                    else {
//                        print("Error")
//                    }
//                }
//            }else{
//                print("No Network");
//            }
//
//        }
    }
    public class func applicationLaunchedWithOption(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        if launchOptions != nil{
            
           let localNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
            if localNotification != nil{
                P5SDKManager.handleLocalNotification(userInfo: localNotification as! [AnyHashable : Any])
            }else{
                let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
                if remoteNotification != nil {
                    P5SDKManager.handlePushNotification(userInfo: remoteNotification as! [AnyHashable : Any])
                }
            }
        }
    }
    public class func updateGeofecneRegions(userInfo : Dictionary<String,Any>){
        print(Date())
        let regions : Array<Dictionary<String, Any>> = userInfo["regions"] as! Array<Dictionary<String, Any>>
//        userInfo.map { ( key : String, value: Any) in
//            if key == "regions" {
//                if value is String {
//                    print(value)
//                    do{
//                    let data = (value as! String ).data(using: String.Encoding.utf8)
//                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
//                    regions = (json as? Array<Dictionary<String, Any>>)!
//
//                    }catch{
//                        return
//                    }
//                }else{
//                    guard
//                        regions = (userInfo["regions"] as? Array<Dictionary<String, Any>>)!
//                        else{
//                            print(Date())
//                            return
//                    }
//                }
//            }
//        }
//
        print(Date())
        print("updateGeofecneRegions")
        P5LoactionInfo.sharedInstance.startMonitoringRegions(regions:regions)
    }
    public class func handleGeofenceEvent(region: CLRegion, onEntry: String){
//        if region is CLBeaconRegion {
//
//                if UIApplication.shared.applicationState == .active {
//                    print(region.identifier)
//                } else {
//                    // Otherwise present a local notification
//                    let beaconName = P5BlueToothManager.sharedInstance.getBeaconName(indentifier: region.identifier)
//                    if beaconName != nil{
//                        let userInfo : Dictionary <String, Any> = [Constants.key_NotificationType : Constants.key_NotificationType_Beacon, Constants.key_NotificationData : beaconName, Constants.key_OnEntry : onEntry]
//                        var msg :String
//                        if onEntry == "1" {
//                            msg = "Welcome to " + beaconName
//                        }else{
//                            msg = "Thanks for visting  " + beaconName + ".\nVisit again"
//                        }
//                    let notification = UNMutableNotificationContent()
//                    notification.body = msg
//                        notification.sound = UNNotificationSound.default
//                    notification.userInfo = userInfo
//                      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
//                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
//
//                        let notificationCenter = UNUserNotificationCenter.current()
//                        notificationCenter.add(request) { (error) in
//                            if error != nil {
//                                print("Error: handleGeofenceEvent notfication eroor " + error.debugDescription)
//                            }
//                        }
//                   // UIApplication.shared.presentLocalNotificationNow(notification)
//                    }
//                }
//        }else{
//            let regionData : Dictionary<String, Any>? = P5LoactionInfo.sharedInstance.getRegionWith(identifier: region.identifier)
//            let userInfo : Dictionary <String, Any> = [Constants.key_NotificationType : Constants.key_NotificationType_GeoFence, Constants.key_NotificationData : regionData!, Constants.key_OnEntry : onEntry]
//
//            if regionData != nil {
//                var msg = regionData?["GeofenceName"] as? String
//                var offLine = Constants.value_offlineMode
//                if P5SDKManager.sharedInstance.checkNetworkRecheablity(){
//                    offLine = Constants.value_onlineMode
//                }
//                P5DBStoreManager.sharedInstance.addGeoFenceEeventData(geoFenceName: msg!, type: onEntry, offline: offLine)
//                if onEntry == "1"{
//                    msg = "Welcome to " + region.identifier
//                }else{
//                    msg = "Thanks for visting " + region.identifier + ".\nVisit again"
//                }
//                if UIApplication.shared.applicationState == .active {
//                    P5SDKManager.sharedInstance.geofenceRegionDate = userInfo
//                    P5SDKManager.sharedInstance.getloactionForGeofence()
//                } else {
//                    // Otherwise present a local notification
//
//                    let notification = UNMutableNotificationContent()
//                    notification.body = msg ?? ""
//                    notification.sound = UNNotificationSound.default
//                    notification.userInfo = userInfo
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
//                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
//
//                    let notificationCenter = UNUserNotificationCenter.current()
//                    notificationCenter.add(request) { (error) in
//                        if error != nil {
//                            print("Error: handleGeofenceEvent notfication eroor " + error.debugDescription)
//                        }
//                    }
//
//                }
//            }
//        }
        
    }
    func getloactionForGeofence(){
        P5LoactionInfo.sharedInstance.updateLocationForGeofence = true
        P5LoactionInfo.sharedInstance.delegate = self
        P5LoactionInfo.sharedInstance.determineMyCurrentLocation();
    }
    func getGeoFencePushCampiagn (params : Dictionary <String, String>,beaconName : String, geofenceName : String){
        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
            print("Invalid Packagename")
            return
        }
        
//        var params : Dictionary<String, String> = Dictionary()
//        params.
        
        let url = Constants.base_url + Constants.api_GetPushCampaign
        P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: params) { (result, success) in
            if success == true && result != nil {
                if result is Array<Any> {
                    let resultArray = result as? Array<Any>
                    if (resultArray?.count)! > 0{
                        let params  = resultArray?[0] as? Dictionary <String, Any>
                        if params != nil{
                            P5SDKManager.sharedInstance.showPushCampaign(userInfo: params!,beaconName: beaconName, geofenceName: geofenceName)
                        }
                    }
                }
            }
            else {
                print("Error")
            }
        }
    }
    func updateLocationForGeoFence() {
        P5LoactionInfo.sharedInstance.updateLocationForGeofence = false
        var params : Dictionary<String, String> = Dictionary()
        let geofenceData : Dictionary <String, Any> = P5SDKManager.sharedInstance.geofenceRegionDate!
        let regionData : Dictionary <String, Any> = geofenceData[Constants.key_NotificationData] as! Dictionary<String, Any>;
        let entry : String = geofenceData[Constants.key_OnEntry] as! String;
        params.updateValue(regionData[Constants.key_MobilePushId] as! String, forKey: Constants.key_PushId)
        params.updateValue(entry, forKey: Constants.key_Entry)
        params.updateValue(P5LoactionInfo.sharedInstance.lat, forKey: Constants.key_EntryLat)
        params.updateValue(P5LoactionInfo.sharedInstance.lon, forKey: Constants.key_EntryLng)
        params.updateValue(p5getAppKey, forKey: Constants.key_AppKey)
        params.updateValue(P5SessionId.sharedInstance.getSessionId(), forKey: Constants.key_SessionId)
        params.updateValue(P5DeviceInfo.sharedInstance.getDeviceId(), forKey: Constants.key_DeviceId)
        P5SDKManager.sharedInstance.getGeoFencePushCampiagn(params: params,beaconName: "",geofenceName:regionData[Constants.key_GeofenceName] as! String )
    }

    public class func trackEvents(name : String, type: String, value:String){
        P5SDKManager.sharedInstance.trackEvents(name: name, type: type, value: value);
    }
    func trackEvents(name : String, type: String, value:String){
        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil{
            return;
        }
        var offLine = Constants.value_offlineMode
        if checkNetworkRecheablity(){
            offLine = Constants.value_onlineMode
        }
//        P5DBStoreManager.sharedInstance.addEeventData(appKey: p5getAppKey, name: name, type: type, value: value, deviceId: P5DeviceInfo.sharedInstance.getDeviceId(), offline: offLine)
        if offLine == Constants.value_onlineMode {
            pushAllTrackEvent()
        }
    }
    func pushAllTrackEvent() {
//        let allTrackData = P5DBStoreManager.sharedInstance.allTrackData()
//        var params : Dictionary<String, Any> = Dictionary()
//        params.updateValue(p5getAppKey, forKey: Constants.key_appkey)
//        var sadd : Array<Any> = Array()
//        for event in allTrackData{
//            var eventParam : Dictionary<String, String> = Dictionary()
//            eventParam.updateValue(P5SessionId.sharedInstance.getSessionId(), forKey: Constants.key_SessionId)
//            eventParam.updateValue(event.deviceId!, forKey: Constants.key_DeviceId)
//            eventParam.updateValue(event.type!, forKey: Constants.key_EventTrack_Type)
//            eventParam.updateValue(event.name!, forKey: Constants.key_EventTrack_Name)
//            eventParam.updateValue(event.value!, forKey: Constants.key_EventTrack_Value)
//            eventParam.updateValue(event.offline!, forKey: Constants.key_Offline)
//            let dateString = Utility.stringFromDate(date: event.trackDate! as Date)
//            eventParam.updateValue(dateString, forKey: Constants.key_TrackDate)
//            eventData.append(eventParam)
//        }
//        params.updateValue(eventData, forKey: Constants.key_EventData)
//        let url = Constants.base_url + Constants.api_LogDataKey
//        P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: params) { (result, success) in
//            if success == true && result != nil {
//                for event in allTrackData{
//                    P5DBStoreManager.sharedInstance.removeEventTrackData(item: event)
//                }
//            }
//            else {
//                print("Error")
//            }
//        }
    }
    public class func showInAppBannerDialog(screenName : String){
        if screenName.count == 0 {
            return
        }
        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
            print("Invalid Packagename")
            P5SDKManager.sharedInstance.inappQueue = screenName;
        }else{
            P5SDKManager.sharedInstance.inappQueue = "";
            P5SDKManager.sharedInstance.getFormData(screenName: screenName);
        }
    }
    public class func loadBanner(screenName : String, bannerView: UIView, delegate : P5BannerDelegate){
        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
            print("Invalid Packagename")
            P5SDKManager.sharedInstance.bannerQueue = screenName;
            P5SDKManager.sharedInstance.bannerView = bannerView
            P5SDKManager.sharedInstance.bannerDelegate = delegate;
        }else{
            P5SDKManager.sharedInstance.bannerQueue = "";
            P5SDKManager.sharedInstance.bannerView = nil
//            P5SDKManager.sharedInstance.delegate = nil;
            let p5BannerView = P5BannerView()
            p5BannerView.setDelagate(delegate: delegate)
            bannerView.addSubview(p5BannerView);
            Utility.setAutolayout(toView: p5BannerView, inView: bannerView, attributes: "0,0,0,0", fieldPosition: FieldPosition.None, topView: UIView(), topViewAttibutes: "0,0,0,0", width: 0, alignment: "Left")
            p5BannerView.frame = bannerView.bounds
            P5SDKManager.sharedInstance.getBannerData(screenName: screenName,imageView: p5BannerView/*, closeBtn: closeBtn*/);
        }
    }
    
    func getFormData(screenName : String){
        print("getFormData called");
        let param = [Constants.key_appkey: p5getAppKey,
                     Constants.key_FieldType : "2",
                     Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
                     Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
                     Constants.key_ScreenName:screenName/*"com.plumb5.p5testnew.MainActivity"*/,
                     Constants.key_EventId:"",
                     Constants.key_EventValue:"",
                     Constants.key_PageParameter:""]
        
        let url = Constants.base_url + Constants.api_GetField
        
        if checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: param) { (result, success) in
                print("getFormData got response");
                if success == true && result != nil {
                    let array = result as? Array<Any>
//                    self.processGetFieldData(array: array!,screenName: screenName)
                    
                }
                else {
                    print("Error")
                }
            }
        }else{
            print("No Network");
        }
    }
    func getBannerData(screenName : String, imageView: P5BannerView/*, closeBtn: UIButton */){
        let param = [Constants.key_appkey: p5getAppKey,
                     Constants.key_FieldType : "1",
                     Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
                     Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
                     Constants.key_ScreenName:screenName/*"com.plumb5.p5testnew.MainActivity"*/,
            Constants.key_EventId:"",
            Constants.key_EventValue:"",
            Constants.key_PageParameter:""]
        imageView.screenName = screenName;
        let url = Constants.base_url + Constants.api_GetField
        
        if checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: param) { (result, success) in
                if success == true && result != nil {
                    let array = result as? Array<Any>
//                    self.processGetFieldData_Banner(array: array!,imageView: imageView/*, closeBtn: closeBtn*/)
                }
                else {
                    print("Error")
                }
            }
        }else{
            print("No Network");
        }
    }
    
    func processGetFieldData(array : NSDictionary,screenName:String){
      
            createDialog(object: array,screenName: screenName)
       
        
    }
    func processGetFieldData_Banner(array : NSDictionary, imageView: P5BannerView/*, closeBtn: UIButton*/){
        let obj = array[0] as! NSDictionary;
        let Status = obj.value(forKey: "Status") as! Bool
        if Status {
            createBanner(object: obj, banner: imageView/*, closeBtn: closeBtn*/)
        }
        
    }
    func createDialog(object : NSDictionary, screenName: String){
        let keyWindow = UIWindow.key
        let banner : InAppBanner = InAppBanner()
        banner.screenName = screenName;
//        banner.frame = (keyWindow?.frame)!
        keyWindow?.addSubview(banner);
        keyWindow?.bringSubviewToFront(banner)
//        keyWindow?.rootViewController?.view.addSubview(banner)
//        keyWindow?.rootViewController?.view.bringSubview(toFront: banner)
        banner.translatesAutoresizingMaskIntoConstraints = false;
        let views : [String : Any] = ["formView":banner]
        let horizontalVisualString = "|[formView]|"
        let verticalVisualString = "V:|[formView]|"
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints)
        banner.dataModel = object
    }
    func createBanner(object : NSDictionary, banner: P5BannerView/*, closeBtn: UIButton*/){
//        let banner : P5BannerView = P5BannerView()
//        banner.closeBtn = closeBtn
        banner.dataModel = object
    }
    /**
     Device registration, this method will access device information using UIDevice and push it to the P5Plum server
     
     @param void
     
     @return void
     */
    
    public class func registerDevice() {
        
        P5SDKManager.sharedInstance.registerDevice()
    }
    
    /**
     User registration, this method will push user information along with the device id
     
     @param  name,email,phoneNumber,extraParam
     
     - parameter name: String value
     - parameter email: String value with valid email
     - parameter phoneNumber: String value with valid phoneNumber
     - parameter extraParam: String value
     
     @return void
     */
    
    public class func registerUser(name: String,email: String,phoneNumber: String,extraParam: String){
        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
//            P5DBStoreManager.sharedInstance.userAdd(name: name, email: email, phone: phoneNumber)
        }else{
            P5SDKManager.sharedInstance.registerUser(name: name, email: email, phoneNumber: phoneNumber, extraParam: extraParam)
        }
    }
    public class func initSession(screenName: String, paramDict:String ){
        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
            print("Invalid Packagename")
        }else{
            P5SDKManager.sharedInstance.initSession(screenName: screenName, paramDict: paramDict)
        }
        
    }
    
    /**
     This method will kick start the Plumb5 SDK Manager analytics session
     
     @param  key,version
     
     - parameter key: String value
     - parameter version: String value
     
     @return void
     */
    
    
    
    
    public class func initP5SDK(key:String,url:String ,completion: @escaping (_ status : Bool) -> ()) {
      //  P5BlueToothManager.sharedInstance.startMonitoringDummyBeacon()
        if key.count == 0 {
            print("You must provide AppKey")
            return
        }
        if url.count == 0 {
            print("You must provide service url")
            return
        }
        P5SDKManager.sharedInstance.p5getAppKey = key
        P5SDKManager.sharedInstance.p5getUrl = url
        P5SDKManager.sharedInstance.cache = NSCache()
        P5SDKManager.sharedInstance.p5Version = Constants.version
        P5SDKManager.sharedInstance.validatAppKey { (status) in
            completion(status)
          //  P5SDKManager.sharedInstance.getAllBeacons()
        //    P5SDKManager.sharedInstance.getAllGeoFenceData()

        }
    }

    public func validatAppKey(completion: @escaping (_ status : Bool) -> ()){
        if P5SDKManager.sharedInstance.p5getAppKey.count == 0 {
            print("You must provide AppKey")
            return
        }
//        let bundleIdentifier = Bundle.main.bundleIdentifier
      //  let appKeyInput = Constants.key_AppKey + "=" + P5SDKManager.sharedInstance.p5getAppKey
//        let packageNameInput = Constants.key_PackageName + "=" + bundleIdentifier!
//       let url = Constants.base_url + Constants.api_ValidatAppKey + "?" + appKeyInput
        let url = Constants.base_url + Constants.api_ValidatAppKeyNew
        
  
        //newCode//
        
        var appKeyParam : Dictionary<String, String> = Dictionary()
        appKeyParam.updateValue(P5SDKManager.sharedInstance.p5getAppKey, forKey: Constants.key_AppKey)
        P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: appKeyParam) { (result, success
        ) in
    
            if success == true && result  != nil {
                if let json = result {
                    print("JSON: \(json)") // serialized json response
                }
                let rootObj = (JSON(result!).array ?? []);
                if rootObj.count > 0 {
                    let dict = rootObj[0].dictionaryObject
                    //                    let projectNumber = dict!["GcmProjectNo"] as? String
                    let bundleIdentfier = Bundle.main.bundleIdentifier
                    let packageName = dict?["PackageName"] as? String
                    //let packageName = "rootObj"
                    if bundleIdentfier == packageName{
                        P5SDKManager.sharedInstance.p5BundleIdentifier = packageName
                        //                        if P5SDKManager.sharedInstance.inappQueue.characters.count > 0{
                        //                           P5SDKManager.showInAppBannerDialog(screenName: P5SDKManager.sharedInstance.inappQueue)
                        //                        }
                        //                        if P5SDKManager.sharedInstance.bannerQueue.characters.count > 0{
                        //                            P5SDKManager.loadBanner(screenName:  P5SDKManager.sharedInstance.bannerQueue, bannerView:  P5SDKManager.sharedInstance.bannerView!, delegate:  P5SDKManager.sharedInstance.bannerDelegate!)
                        //                        }
                        completion(true)
                    }else{
                        completion(false)
                    }
                }else{
                    completion(false)
                }
            }
            else {
                print("Error")
                completion(false)
            }
        }
           //newCode//
//
//        P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: nil) { (result, success) in
//            if success == true && result != nil {
//                let rootObj = result as! Array<Any>
//                if rootObj.count > 0 {
//                    let dict = rootObj[0] as? Dictionary<String, Any>
////                    let projectNumber = dict!["GcmProjectNo"] as? String
//                    let bundleIdentfier = Bundle.main.bundleIdentifier
//                    let packageName = dict!["PackageName"] as? String
//                    if bundleIdentfier == packageName{
//                        P5SDKManager.sharedInstance.p5BundleIdentifier = packageName
////                        if P5SDKManager.sharedInstance.inappQueue.characters.count > 0{
////                           P5SDKManager.showInAppBannerDialog(screenName: P5SDKManager.sharedInstance.inappQueue)
////                        }
////                        if P5SDKManager.sharedInstance.bannerQueue.characters.count > 0{
////                            P5SDKManager.loadBanner(screenName:  P5SDKManager.sharedInstance.bannerQueue, bannerView:  P5SDKManager.sharedInstance.bannerView!, delegate:  P5SDKManager.sharedInstance.bannerDelegate!)
////                        }
//                        completion(true)
//                    }else{
//                        completion(false)
//                    }
//                }else{
//                    completion(false)
//                }
//            }
//            else {
//                print("Error")
//                completion(false)
//            }
//        }
    }
//    public class func handleLocalNotification(notification : UILocalNotification){
//        let userInfo = notification.userInfo
////        Timer.init(timeInterval: 10, target: self, selector: Selector("receivedLocalNotification:"), userInfo: userInfo, repeats: false)
//        var delay = 10.0
//        if P5SDKManager.sharedInstance.p5BundleIdentifier != nil {
//            delay = 0.1;
//        }
//        if #available(iOS 10.0, *) {
//            Timer.scheduledTimer(withTimeInterval: TimeInterval(delay), repeats: false) { (timer) in
//                let userInfo = userInfo as? NSDictionary
//                let notificationType = userInfo?[Constants.key_NotificationType] as? String
//                if  notificationType == Constants.key_NotificationType_Banner{
//                    let params = userInfo?[Constants.key_NotificationData]
//                    P5SDKManager.sharedInstance.createDialog(object: params as! NSDictionary,screenName: "");
//                }else if notificationType == Constants.key_NotificationType_GeoFence{
//                    P5SDKManager.sharedInstance.geofenceRegionDate = userInfo as? Dictionary<String, Any>
//                    P5SDKManager.sharedInstance.getloactionForGeofence()
//                }else if notificationType == Constants.key_NotificationType_Beacon{
//                    P5SDKManager.sharedInstance.beaconRegionDate = userInfo as? Dictionary<String, Any>
//                }
//            }
//        } else {
//            // Fallback on earlier versions
////            NSTimer.scheduledTimerWithInterval(1.0, target: self, selector: "receivedLocalNotification", userInfo: circle, repeats: true)
//            Timer.init(timeInterval: TimeInterval(delay), target: self, selector: #selector(P5SDKManager.receivedLocalNotification), userInfo: userInfo, repeats: false)
//        }
//    }
    
    public class func handleLocalNotification(userInfo: [AnyHashable : Any]){
       let userInfo = userInfo
        //        Timer.init(timeInterval: 10, target: self, selector: Selector("receivedLocalNotification:"), userInfo: userInfo, repeats: false)
        var delay = 10.0
        if P5SDKManager.sharedInstance.p5BundleIdentifier != nil {
            delay = 0.1;
        }
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(delay), repeats: false) { (timer) in
             
                let notificationType = userInfo[Constants.key_NotificationType] as? String
                if  notificationType == Constants.key_NotificationType_Banner{
                    let params = userInfo[Constants.key_NotificationData]
                    P5SDKManager.sharedInstance.createDialog(object: params as! NSDictionary,screenName: "");
                }else if notificationType == Constants.key_NotificationType_GeoFence{
                    P5SDKManager.sharedInstance.geofenceRegionDate = userInfo as? Dictionary<String, Any>
                    P5SDKManager.sharedInstance.getloactionForGeofence()
                }else if notificationType == Constants.key_NotificationType_Beacon{
                    P5SDKManager.sharedInstance.beaconRegionDate = userInfo as? Dictionary<String, Any>
                }
            }
        } else {
            // Fallback on earlier versions
            Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: #selector(P5SDKManager.receivedLocalNotification), userInfo: userInfo, repeats: false)
//            Timer.init(timeInterval: TimeInterval(delay), target: self, selector: #selector(P5SDKManager.receivedLocalNotification), userInfo: userInfo, repeats: false)
        }
    }
    @objc func receivedLocalNotification(_ timer : Timer){
        let userInfo = timer.userInfo as? NSDictionary
        let notificationType = userInfo?[Constants.key_NotificationType] as? String
        if  notificationType == Constants.key_NotificationType_Banner{
            let params = userInfo?[Constants.key_NotificationData]
            P5SDKManager.sharedInstance.createDialog(object: params as! NSDictionary,screenName: "");
        }else if notificationType == Constants.key_NotificationType_GeoFence{
            P5SDKManager.sharedInstance.geofenceRegionDate = userInfo as? Dictionary<String, Any>
            P5SDKManager.sharedInstance.getloactionForGeofence()
        }else if notificationType == Constants.key_NotificationType_Beacon{
            P5SDKManager.sharedInstance.beaconRegionDate = userInfo as? Dictionary<String, Any>
        }
    }
    public class func handlePushNotification(userInfo : [AnyHashable : Any]){
        let aps = userInfo["aps"] as! [String: AnyObject]
        let isSilent = aps["content-available"]
//        if isSilent != nil{
//            print("Received silent pn")
//            print()
//         //   P5SDKManager.updateGeofecneRegions(userInfo: userInfo as! Dictionary<String, Any>)
//
//        }else{
            P5SDKManager.showNotification(userInfo: userInfo as! Dictionary<String, Any>)
         

    }
    public class func showNotification(userInfo : Dictionary<String, Any>){
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        let alert = aps["alert"]
        var body : String? = ""
        var title : String? = ""
        if alert is Dictionary<String, Any>{
            body = alert?["body"] as? String
            title = alert?["title"] as? String
        }else if alert is String{
            body = alert as? String
        }
        let attachmentUrl = userInfo["attachment-url"] as? String
        let mediaType =  userInfo["media-type"] as? String
        let extraBtn = userInfo[Constants.key_ExtraButtons] as? String
        var params : Dictionary <String, Any> = [:]
        if body != nil {
            body = body?.replacingOccurrences(of: "~A~", with: "")
            params.updateValue(body!, forKey: Constants.key_Message)
        }
        if title != nil {
          title =  title?.replacingOccurrences(of: "~A~", with: "")
            params.updateValue(title!, forKey: Constants.key_Title)
        }
        
        if attachmentUrl != nil && mediaType != nil {
            params.updateValue(attachmentUrl!, forKey: Constants.key_ImageUrl)
            params.updateValue(mediaType!, forKey: Constants.key_MediaType)
        }
        if extraBtn != nil{
            params.updateValue(extraBtn!, forKey: Constants.key_ExtraButtons)
        }
        let pushId = userInfo[Constants.key_MobilePushId]
        
        if pushId != nil {
            params.updateValue(pushId, forKey: Constants.key_MobilePushId)
        }else{
            params.updateValue("", forKey: Constants.key_MobilePushId)
        }
        P5SDKManager.sharedInstance.showPushCampaign(userInfo: params,beaconName: "", geofenceName: "")
    }
    func showPushCampaign(userInfo : Dictionary <String, Any>, beaconName: String, geofenceName:String){
        let keyWindow = UIApplication.shared.windows[0]
        let banner : P5NotificationDetailView = P5NotificationDetailView()
        banner.frame = keyWindow.frame
        keyWindow.addSubview(banner)
        banner.geofenceName = geofenceName
        banner.beaconName = beaconName
        banner.userInfo = userInfo
    }
    
    public class func handleActions(params : Dictionary<String, String>, dataModel: Dictionary<String, Any>,eventType : String){
        let action = params[Constants.key_Action];
        if action?.count == 0 {
            return;
        }
        let actionType : Actions = Actions(rawValue: action!)!
        let redirectUrl : String = params[Constants.key_Redirect]!
        let parameters : String = params[Constants.key_Parameter]!
        let message : String = params[Constants.key_Message]!
        
        P5SDKManager.handleAction(actionType: actionType, redirectUrl: redirectUrl, parameters: parameters,message:message,  dataModel: dataModel,eventType : eventType)

    }
    public class func handleAction(actionType: Actions, redirectUrl : String, parameters : String, message: String,dataModel: Dictionary<String, Any>,eventType : String){
    
        switch actionType {
        case .Form:
            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect : redirectUrl, Constants.key_Parameter : parameters]);
            break;
        case .Dismiss:
            break
        case .RedirectToScreen:
            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect : redirectUrl, Constants.key_Parameter:parameters]);
            break;
        case .ExternalURL :
            guard let url = URL.init(string: redirectUrl)
                else{
                    return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            break;
        case .DeepLinkingURL :
            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect : redirectUrl, Constants.key_Parameter:parameters]);
            break;
        case .Copy:
            let pasteboard = UIPasteboard.general;
            pasteboard.string = redirectUrl;
//            P5SDKManager.sharedInstance.currentVC?.showToast(message: message)
            break;
        case .Call:
            guard let url = URL.init(string: "telprompt://" + redirectUrl)
                else{
                    return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            break;
        case .Share:
            P5SDKManager.sharedInstance.share(text: redirectUrl)
            break;
        case .RemindLater:
             let center = UNUserNotificationCenter.current()
            let reminder = UNMutableNotificationContent()
//            let fireDate = Date().addingTimeInterval((redirectUrl as NSString).doubleValue * 60.0)
           let fireDate =  (redirectUrl as NSString).doubleValue * 60.0
             
           
            reminder.userInfo = [Constants.key_NotificationType : Constants.key_NotificationType_Banner, Constants.key_NotificationData : dataModel]
            reminder.body = parameters
    
             let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireDate, repeats: false)
             
             let request = UNNotificationRequest(identifier: UUID().uuidString, content: reminder, trigger: trigger)
             center.add(request)
          //  UIApplication.shared.scheduleLocalNotification(reminder);
            break;
        case .EventTracking:
            P5SDKManager.trackEvents(name: redirectUrl, type: eventType, value: parameters)
            break;
        case .TextMessage :
            P5SDKManager.sharedInstance.initiateSMS(number: redirectUrl, msg: parameters)
            break;
        case .Permission:
            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect : redirectUrl, Constants.key_Parameter:parameters]);
            break;
        case .None:
            break;
        default:
            break;
        }
    }
    func initiateSMS(number : String, msg : String){
//        if (MFMessageComposeViewController.canSendText()) {
//            let controller = MFMessageComposeViewController()
//            controller.body = msg
//            controller.recipients = [number]
//            controller.messageComposeDelegate = P5SDKManager.sharedInstance.currentVC! as MFMessageComposeViewControllerDelegate
//            P5SDKManager.sharedInstance.currentVC?.present(controller, animated: true, completion: nil)
//        }
    }
    
    func share(text : String){
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = P5SDKManager.sharedInstance.currentVC?.view // so that iPads won't crash
        // present the view controller
        P5SDKManager.sharedInstance.currentVC?.present(activityViewController, animated: true, completion: nil)
    }
    
    public class func updateFormResponse(mobileFormID : Any, formResponse : String, bannerView: String, bannerClick : String, bannerClose : String, btnName : String, geofenceName : String, beaconName:String, screenName:String, widgetName:String)
    {
     
            var params : Dictionary <String, Any> = Dictionary()
            params.updateValue(mobileFormID, forKey: Constants.key_MobileFormId)
            params.updateValue(formResponse, forKey: Constants.key_FormResponses)
            params.updateValue(bannerView, forKey: Constants.key_BannerView)
            params.updateValue(bannerClick, forKey: Constants.key_BannerClick)
            params.updateValue(bannerClose, forKey: Constants.key_BannerClose)
            if btnName.count > 0{
               params.updateValue(btnName, forKey: Constants.key_ButtonName)
            }
            
       
            
            
            params.updateValue(P5SessionId.sharedInstance.getSessionId(), forKey: Constants.key_SessionId)
            params.updateValue(P5DeviceInfo.sharedInstance.getDeviceId(), forKey: Constants.key_DeviceId)
            params.updateValue("0", forKey: "SendReport")
            params.updateValue(widgetName, forKey: "WidgetName")
            if screenName.count > 0{
                params.updateValue(screenName, forKey: "ScreenName")
            }
            params.updateValue("0", forKey: "WorkFlowDataId")
            params.updateValue("0", forKey: "P5UniqueId")
            
            print("params = %@",params)
            let url = Constants.base_url + Constants.api_formResponses
            if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
                P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: params) { (result, success) in
                    if success == true && result != nil {
                        print("success " + url + "result = " + (result as? String ?? "") );
                    }
                    else {
                        print("Error")
                    }
                }
            }else{
                print("No Network");
            }


        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
