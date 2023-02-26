//
//  P5DeviceInfo.swift
//  Plumb5SDK
//
//  Created by Shama on 4/30/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import CoreTelephony



import SystemConfiguration.CaptiveNetwork

 class P5DeviceInfo {
    
    static let sharedInstance = P5DeviceInfo()
    
    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    private init() {
        print("P5DeviceInfo has been initialized")
    }
    
    func getOS() -> String {
        return Constants.value_ios
    }
    
    func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    func getDeviceModel() -> String {
        return UIDevice.current.model
    }
    
    func getDeviceId() -> String {
        let keychainWrapper = KeychainWrapper()
        var deviceUUID = keychainWrapper.myObject(forKey: kSecAttrLabel) as? NSString;
        if ( deviceUUID == nil || (deviceUUID?.isEqual(to: "Item label"))!) {
            deviceUUID = UIDevice.current.identifierForVendor!.uuidString as NSString
            keychainWrapper.mySetObject(deviceUUID, forKey: kSecAttrLabel)
        }else{
            
        }
//        print("deviceUUID =" + (deviceUUID! as String))
        return deviceUUID! as String
    }
    
    func getResolution() -> String {
        let description : String = UIScreen.main.nativeBounds.debugDescription
        var myStringArr = description.components(separatedBy: ", ")
        if myStringArr.count > 3{
            let resolution = myStringArr[2] + "x"  + myStringArr[3].replacingOccurrences(of: ")", with: "")
            
            return resolution
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let screenSizeInString = screenWidth.description + "x" + screenHeight.description
        return screenSizeInString
    }
    
//    func getCarrier() -> String {
//        let networkInfo = CTTelephonyNetworkInfo()
//        let carrier = networkInfo.subscriberCellularProvider
//        
//        // Get carrier name
//        var carrierName = carrier?.carrierName
//        
//        if (carrierName == nil ) {
//            carrierName = Constants.value_wifi
//        }
//        
//        return carrierName!
//    }
    func printCurrentWifiInfo() {
        if let interface = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interface) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interface, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                if let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString), let interfaceData = unsafeInterfaceData as? [String : AnyObject] {
                    // connected wifi
                    print("BSSID: \(String(describing: interfaceData["BSSID"])), SSID: \(String(describing: interfaceData["SSID"])), SSIDDATA: \(String(describing: interfaceData["SSIDDATA"]))")
                } else {
                    // not connected wifi
                }
            }
        }
    }
    func getCarrier() -> String {
        let reachability = Reachability()!
        
        if reachability.connection != .none {
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                return Constants.value_wifi
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
        
        
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        // Get carrier name
        var carrierName = carrier?.carrierName
        
        if (carrier?.mobileNetworkCode == nil ) {
            carrierName = Constants.value_wifi
        }else if (carrierName != nil && carrierName?.caseInsensitiveCompare("carrier") == .orderedSame){
            let deviceInfo = Constants.key_mobileNetworkCode + ":" + (carrier?.mobileNetworkCode)! + "," +
                Constants.key_CountryCode + ":" + (carrier?.mobileCountryCode)! + "," +
                Constants.key_isoCountryCode + ":" + (carrier?.isoCountryCode)!
            
            carrierName = deviceInfo.description
        }
        
        
        return carrierName!
    }
    
    func getDeviceInfoAsJson() -> [String:String] {
        
        let deviceInfo = [Constants.key_manufacturer: Constants.value_apple,
                          Constants.key_name: P5DeviceInfo.sharedInstance.getDeviceModel(),
                          Constants.key_os:Constants.value_ios,
                          Constants.key_id:P5DeviceInfo.sharedInstance.getDeviceId(),
                          Constants.key_osversion:P5DeviceInfo.sharedInstance.getOSVersion(),
                          Constants.key_carriername:P5DeviceInfo.sharedInstance.getCarrier(),
                          Constants.key_resolution:P5DeviceInfo.sharedInstance.getResolution(),
                          Constants.key_appversion:P5SDKManager.sharedInstance.p5Version]
        
        return deviceInfo
    }
    
}
