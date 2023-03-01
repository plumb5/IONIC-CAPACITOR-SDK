import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(Plumb5Plugin)
public class Plumb5Plugin: CAPPlugin {

    
    override public func load() {
        let accountId = Bundle.main.object(forInfoDictionaryKey: "accountId") as? String ?? ""
        let appKey = Bundle.main.object(forInfoDictionaryKey: "appKey") as? String ?? ""
        let serviceURL = Bundle.main.object(forInfoDictionaryKey: "serviceURL") as? String ??  ""
        P5SDKManager.sharedInstance.p5getUrl =  serviceURL
        P5SDKManager.sharedInstance.p5getAppKey =  appKey
      
    }
    @objc func initializePlumb5(_ call: CAPPluginCall) {
        
       
        let url = Constants.base_url + Constants.api_ValidatAppKeyNew
        print(url)
        
                P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: nil) { (result, success) in
                    if success == true && result != nil {
                        let rootObj = (JSON(result!).array ?? []);
                        if rootObj.count > 0 {
                            let dict = rootObj[0].dictionaryObject
        //                    let projectNumber = dict!["GcmProjectNo"] as? String
                            let bundleIdentfier = Bundle.main.bundleIdentifier
                            let packageName = dict!["IosPackageName"] as? String
                            if bundleIdentfier == packageName{
                                P5SDKManager.sharedInstance.p5BundleIdentifier = packageName
                                self.deviceRegistration()

        //                        }
                                call.resolve()
                                print("API" ,Constants.api_ValidatAppKey," successful")
                            }else{
                                print("Expected valid apiKey for the bundle")
                                call.reject("Expected valid apiKey for the bundle")
                            }
                        }else{
                            print("API result unsuccessful")
                            call.reject("API result unsuccessful")
                        }
                    }
                else {
                        print("API network unsuccessful")
                        call.reject("API network unsuccessful")
                    }
                }
                                                              
        
        }
    
    func deviceRegistration() {
        
        let deviceInfo = [
                         "DeviceId": P5DeviceInfo.sharedInstance.getDeviceId(),
                          "Manufacturer":Constants.value_apple,
                          "DeviceName": P5DeviceInfo.sharedInstance.getDeviceModel(),
                          "OS": Constants.value_apple,
                          "OsVersion": P5DeviceInfo.sharedInstance.getOSVersion(),
                          "AppVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ??  "",
                          "CarrierName": P5DeviceInfo.sharedInstance.getCarrier(),
                          "DeviceDate": Date.getCurrentDate(),
                          "GcmRegId": "",
                          "Resolution":P5DeviceInfo.sharedInstance.getResolution(),
                          "InstalledStatus":true,
                          "GcmSettingsId":0,
                          "IsInstalledStatusDate":Date.getCurrentDate()
                          
        ] as! [String : AnyObject]

        
     
        let url = Constants.base_url + Constants.api_RegisterDevice
        
        if (P5SDKManager.sharedInstance.checkNetworkRecheablity()) {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: deviceInfo) { (result, success) in
                if success == true && result != nil {
                    print((result as? String)?.description ?? "")
                   
                    print("API" ,Constants.api_ValidatAppKey," successful")
                    
                }
                else {
                    print("API result unsuccessful")
                
                }
            }
        }else{
            print("API network unsuccessful")
 
        }
    }
    
    @objc func tracking(_ call: CAPPluginCall) {
        
        let datetime =  P5SessionId.sharedInstance.getCurrentDate();
        let trackData = [Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
                         Constants.key_GcmRegId:"",
                         Constants.key_ScreenName:call.getString("ScreenName", ""),
                         Constants.key_CampaignId:"0",
                         Constants.key_NewSession:"0",
                         Constants.key_DeviceId:P5DeviceInfo.sharedInstance.getDeviceId(),
                         Constants.key_Offline:"0",
                         Constants.key_TrackDate:datetime,
                         Constants.key_GeofenceId:"0",
                         Constants.key_Locality:P5LoactionInfo.sharedInstance.locality,
                         Constants.key_City:P5LoactionInfo.sharedInstance.city,
                         Constants.key_State:P5LoactionInfo.sharedInstance.state,
                         Constants.key_Country:P5LoactionInfo.sharedInstance.country,
                         Constants.key_CountryCode:P5LoactionInfo.sharedInstance.countryCode,
                         Constants.key_Latitude:P5LoactionInfo.sharedInstance.lat,
                         Constants.key_Longitude:P5LoactionInfo.sharedInstance.lon,
                         Constants.key_PageParameter:call.getString("PageParameter", "")];



        let url = Constants.base_url + Constants.api_initSession

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: trackData) { (result, success) in
                if success == true && result != nil {

                 
                }
                else {
                    print("Error")
                }
             
            }
        }else{
 
        }


    }
    
    
    
    @objc func eventPost(_ call: CAPPluginCall) {
        
        let datetime =  P5SessionId.sharedInstance.getCurrentDate();
        
        let eventData = [Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
                         Constants.key_DeviceId:P5DeviceInfo.sharedInstance.getDeviceId(),
                         Constants.key_Offline:"0",
                         Constants.key_TrackDate:datetime]
        
        let url = Constants.base_url + Constants.api_EventResponses

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: eventData) { (result, success) in
                if success == true && result != nil {
                    
                
                                 
                                }
                                else {
                                    print("Error")
                                }
                        
                            }
                        }else{
                      
                        }

                         
                         
                         
        
    }
    
    @objc func setUserDetails(_ call: CAPPluginCall) {
       
        
        let param = [
            "DeviceId": P5DeviceInfo.sharedInstance.getDeviceId(),
            "Name": call.getString("Name",""),
            "EmailId": call.getString("EmailId","") ,
            "PhoneNumber": call.getString("PhoneNumber","") ,
            "LeadType": 1,
            "Gender": call.getString("Gender","") ,
            "Age": call.getString("Age","") ,
            "AgeRange": call.getString("AgeRange","") ,
            "MaritalStatus": call.getString("MaritalStatus","") ,
            "Education": call.getString("Education","") ,
            "Occupation": call.getString("Occupation","") ,
            "Interests": call.getString("Interests","") ,
            "Location": call.getString("Location",""),
        ]  as [String : Any]

        let url = Constants.base_url + Constants.api_RegisterUser

        if P5SDKManager.sharedInstance.checkNetworkRecheablity() {
            P5ServiceManager.sharedInstance.sendPostRequestWithURL(url: url, paramDict: param) { (result, success) in
                if success == true && result != nil {

                }
                else {
                    print("Error")
                }
            }
        }
    }
    
    @objc   func pushResponse(_ call: CAPPluginCall){
     
        let param = [
                     Constants.key_FieldType : "1",
                     Constants.key_DeviceId: P5DeviceInfo.sharedInstance.getDeviceId(),
                     Constants.key_SessionId: P5SessionId.sharedInstance.getSessionId(),
                     Constants.key_ScreenName:call.getString("ScreenName",""),
            Constants.key_EventId:"",
            Constants.key_EventValue:"",
            Constants.key_PageParameter:call.getString("PageParameter","")]
       
        let url = Constants.base_url + Constants.api_GetField
        
        if P5SDKManager.sharedInstance.checkNetworkRecheablity(){
            P5ServiceManager.sharedInstance.sendGetRequestWithURL(url: url, paramDict: param) { (result, success) in
                if success == true && result != nil {
                    let response = result as! NSDictionary
//                    let array = result as? Array<Any>
                    P5SDKManager.sharedInstance.processGetFieldData(array: response,screenName: call.getString("ScreenName",""))
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



