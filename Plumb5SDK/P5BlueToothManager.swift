//
//  P5BlueToothManager.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 7/22/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth

class P5BlueToothManager: NSObject, CLLocationManagerDelegate, CBCentralManagerDelegate {
    public static let sharedInstance = P5BlueToothManager()
    var bluetoothManager : CBCentralManager?
    let locationManager = CLLocationManager()
    var reachableBLE : Array <P5BeaconRegion> = Array()
    var nonReachableBLE : Array <P5BeaconRegion> = Array()
    
    func startMonitoringRegions(regions: Array<Any>){
        stopMinitoringAllRegions()
        locationManager.delegate = self
        var items = Array<P5BeaconRegion>()
        let p5BeaconRegion1 = P5BeaconRegion.init(proximityUUID: "7B44B47B-52A1-5381-90C2-F09B6838C5D4", major: 0, minor: 0, identifier: "60", beaconName: "Shahid_Akhtar Test", pushId: "2", entryExit: "1", radius: "3")
        let clBeaconRegion1  = p5BeaconRegion1.createCLBeaconRegion()
        locationManager.startMonitoring(for: clBeaconRegion1)
        locationManager.startRangingBeacons(in:clBeaconRegion1)
        items.append(p5BeaconRegion1)
        
        if regions.count == 0 {
            
        }else{
            for i in 0...regions.count-1{
                let obj = regions[i]
                if obj is Dictionary <String,Any> {
                    let region = obj as! Dictionary <String,Any>
                    guard
                        let BeaconId = region[Constants.key_BeaconId],
                        let BeaconName = region[Constants.key_BeaconName] ,
                        let BeaconUuid = region[Constants.key_BeaconUuid] ,
                        let EntryExist = region[Constants.key_EntryExist] ,
                        let MajorId = region[Constants.key_MajorId],
                        let MinorId = region[Constants.key_MinorId] ,
                        let PushId = region[Constants.key_PushId] ,
                        let Radius = region[Constants.key_Radius]
                        else{
                            continue
                    }
                    let majorValue = UInt16(MajorId as! NSInteger)
                    let minorValue = UInt16(MinorId as! NSInteger)
                    let p5BeaconRegion = P5BeaconRegion.init(proximityUUID: BeaconUuid as! String,
                                                             major: majorValue,
                                                             minor: minorValue,
                                                             identifier: String(describing: BeaconId),
                                                             beaconName: BeaconName as! String,
                                                             pushId: String(describing: PushId),
                                                             entryExit: String(describing: EntryExist),
                                                             radius: String(describing: Radius))
                    let clBeaconRegion  = p5BeaconRegion.createCLBeaconRegion()
                    locationManager.startMonitoring(for: clBeaconRegion)
                    locationManager.startRangingBeacons(in:clBeaconRegion)
                    items.append(p5BeaconRegion)
                }else{
                    continue
                }
            }
        }
        print(locationManager.monitoredRegions)
        saveBeaconRegions(items: items)
    }
    func getAllBeacons() -> Array<P5BeaconRegion>?{
        var items = Array<P5BeaconRegion>()
        guard let storedItems = UserDefaults.standard.array(forKey: Constants.key_SavedBeaconData) as? [Data] else { return []}
        for itemData in storedItems {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? P5BeaconRegion else { continue }
            items.append(item)
        }
        return items
    }
    func getBeaconName(indentifier : String) -> String{
        guard let storedItems = UserDefaults.standard.object(forKey: Constants.key_SavedBeaconNames) as? Dictionary<String, String> else { return ""}
        guard let beaconName = storedItems[indentifier] else {
            return ""
        }
        return beaconName;
    }
    func saveBeaconRegions (items : Array<P5BeaconRegion>){
        var itemsData = [Data]()
        var beaconIdAndName : Dictionary <String,String> = Dictionary()
        for item in items {
            beaconIdAndName.updateValue(item.beaconName, forKey: item.identifier)
            let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
            itemsData.append(itemData)
        }
        UserDefaults.standard.set(itemsData, forKey: Constants.key_SavedBeaconData)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(beaconIdAndName, forKey: Constants.key_SavedBeaconNames)
        UserDefaults.standard.synchronize()
    }
    func stopMinitoringAllRegions(){
        guard let regions : Array<P5BeaconRegion> = getAllBeacons()
            else{
                return
        }
        
        for region in regions{
            let clBeaconRegion  = region.createCLBeaconRegion()
            locationManager.stopMonitoring(for: clBeaconRegion)
            locationManager.stopRangingBeacons(in: clBeaconRegion)
        }
        UserDefaults.standard.removeObject(forKey:  Constants.key_SavedBeaconData)
        UserDefaults.standard.removeObject(forKey:  Constants.key_SavedBeaconNames)
        UserDefaults.standard.synchronize()
    }
    
    //    public func getBeconDetailsWith(beaconId : String, majorId : CLBeaconMajorValue, minorId: CLBeaconMinorValue) -> P5BeaconRegion?{
    //        let regions : Array<P5BeaconRegion> = getAllBeacons()!
    //        for region in regions{
    //            if region.uuid == beaconId && region.majorValue == majorId && region.minorValue == minorId{
    //                return region
    //            }
    //        }
    //        return nil
    //
    //    }
    public func getBeconDetailsWith(beaconId : String) -> P5BeaconRegion?{
        let regions : Array<P5BeaconRegion> = getAllBeacons()!
        for region in regions{
            if region.identifier == beaconId {
                return region
            }
        }
        return nil
        
    }
    
    public func startMonitoringDummyBeacon(){
        locationManager.delegate = self
        //        bluetoothManager = CBCentralManager.init(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : NSNumber.init(value: true)])
        //        let p5BeaconRegion = P5BeaconRegion.init(proximityUUID: "7B44B47B-52A1-5381-90C2-F09B6838C5D4", major: 0, minor: 0, identifier: "46", beaconName: "Shahid_Akhtar Test", pushId: "113", entryExit: "1", radius: "3")
        //        let clBeaconRegion  = p5BeaconRegion.createCLBeaconRegion()
        //        locationManager.startMonitoring(for: clBeaconRegion)
        //        locationManager.startRangingBeacons(in:clBeaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            //            let uuid = beacon.proximityUUID.uuidString
            let p5region = getBeconDetailsWith(beaconId: region.identifier)
            if p5region == nil {
                continue
            }
            let radius = (p5region?.radius! as! NSString).floatValue
            let accuracy = String(format: "%.2f", beacon.accuracy)
            let distance = (accuracy as NSString).floatValue
            if distance < 0 {
                if isAlreadyReachable(region: p5region!){
                    print("-1 exit beacon Name = " + (p5region?.beaconName)! )
                    P5SDKManager.getPushCampaignForBLE(region: p5region!, radius: accuracy, entry: "2")
                    removeReachable(region: p5region!)
                    
                }
            }else if distance <= radius{
                
                let wasReachable = isAlreadyReachable(region: p5region!)
                if !wasReachable  {
                    print("enters beacon Name = " + (p5region?.beaconName)! )
                    P5SDKManager.getPushCampaignForBLE(region: p5region!, radius: accuracy, entry: "1")
                    reachableBLE.append(p5region!)
                }
            }else if isAlreadyReachable(region: p5region!){
                print("exit beacon Name = " + (p5region?.beaconName)! )
                P5SDKManager.getPushCampaignForBLE(region: p5region!, radius: accuracy, entry: "2")
                removeReachable(region: p5region!)
            }
            
            print("distancs = " + accuracy)
        }
    }
    func isAlreadyReachable(region : P5BeaconRegion) -> Bool{
        for reachable in reachableBLE{
            if reachable.uuid == region.uuid && reachable.minorValue == region.minorValue && reachable.minorValue == region.minorValue {
                return true
            }
        }
        return false
    }
    func isAlreadyNotReachable(region : P5BeaconRegion) -> Bool{
        for reachable in nonReachableBLE{
            if reachable.uuid == region.uuid && reachable.minorValue == region.minorValue && reachable.minorValue == region.minorValue {
                return true
            }
        }
        return false
    }
    func removeReachable(region : P5BeaconRegion){
        for i in 0...reachableBLE.count-1{
            let reachable = reachableBLE[i]
            if reachable.uuid == region.uuid && reachable.minorValue == region.minorValue && reachable.minorValue == region.minorValue {
                reachableBLE.remove(at: i);
                return
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .resetting, .poweredOff:
            removeAllReachableBLE()
        default:
            break
        }
    }
    func removeAllReachableBLE(){
        for region in reachableBLE{
            P5SDKManager.getPushCampaignForBLE(region: region, radius: "-1", entry: "2")
        }
        reachableBLE.removeAll()
    }
    
}
