//
//  P5BeaconRegion.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 7/22/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import CoreLocation

class P5BeaconRegion : NSObject, NSCoding {
    @objc var identifier : String!
    @objc var uuid : String!
    var majorValue : CLBeaconMajorValue!
    var minorValue : CLBeaconMinorValue!
    @objc var entryExit : String!
    @objc var beaconName : String!
    @objc var pushId : String!
    @objc var radius : String!
    
    @objc init (proximityUUID : String, major: CLBeaconMajorValue, minor : CLBeaconMinorValue, identifier : String, beaconName : String, pushId : String, entryExit : String, radius : String){
        self.uuid = proximityUUID
        self.majorValue = major
        self.minorValue = minor
        self.identifier = identifier
        self.beaconName = beaconName
        self.radius = radius
        self.pushId = pushId
        self.entryExit = entryExit
    }
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        let aName = aDecoder.decodeObject(forKey: Constants.key_BeaconId) as? String
        identifier = aName ?? ""
        uuid = aDecoder.decodeObject(forKey: Constants.key_BeaconUuid) as? String
        majorValue = UInt16(aDecoder.decodeInteger(forKey: Constants.key_MajorId))
        minorValue = UInt16(aDecoder.decodeInteger(forKey: Constants.key_MinorId))
        entryExit = aDecoder.decodeObject(forKey: Constants.key_EntryExist) as? String
        beaconName = aDecoder.decodeObject(forKey: Constants.key_BeaconName) as? String
        pushId = aDecoder.decodeObject(forKey: Constants.key_PushId) as? String
        radius = aDecoder.decodeObject(forKey: Constants.key_Radius) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: Constants.key_BeaconId)
        aCoder.encode(uuid, forKey: Constants.key_BeaconUuid)
        aCoder.encode(Int(majorValue), forKey: Constants.key_MajorId)
        aCoder.encode(Int(minorValue), forKey: Constants.key_MinorId)
        aCoder.encode(entryExit, forKey: Constants.key_EntryExist)
        aCoder.encode(beaconName, forKey: Constants.key_BeaconName)
        aCoder.encode(pushId, forKey: Constants.key_PushId)
        aCoder.encode(radius, forKey: Constants.key_Radius)
    }

  
    @objc func  createCLBeaconRegion() -> CLBeaconRegion {
        let clBeaconRegion = CLBeaconRegion(proximityUUID: UUID.init(uuidString: self.uuid!)!,
                                            major: self.majorValue! ,
                                            minor: self.minorValue!,
                                            identifier: self.identifier!)
        return clBeaconRegion
    }
    
    
}
