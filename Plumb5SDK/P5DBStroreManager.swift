//
//  P5DBStroreManager.swift
//  Plumb5SDK
//
//  Created by Shama on 5/14/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import CoreData
import SugarRecord

class P5DBStoreManager : NSObject  {
    
    @objc public static let sharedInstance = P5DBStoreManager()
    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    private override init() {
        print("P5DBStoreManager has been initialized")
    }

    lazy var db: CoreDataDefaultStorage = {
        let store = CoreDataStore.named("P5DB")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()
    
    func coreDataStorage() -> CoreDataDefaultStorage {
        let store = CoreDataStore.named("P5DB")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }
    
    @objc func userAdd(name:String,email:String,phone:String) {
        try! db.operation { (context, save) -> Void in
            let _object: UserDetails = try! context.new()
            _object.name = name
            _object.phone = phone
            _object.email = email
            try! context.insert(_object)
            save()
        }
    }

    @objc func screenFlowAdd(screenName:String,extraParam:String, dateTime:String, sessionId:String, offlineMode:String) {
        try! db.operation { (context, save) -> Void in
            let _object: ScreenFlow = try! context.new()
            _object.screenName = screenName
            _object.extraParam = extraParam
            _object.dateTime = dateTime
            _object.sessionId = sessionId
            _object.offline = offlineMode
            try! context.insert(_object)
            save()
        }
    }
    @objc func addEeventData(appKey:String, name:String,type:String,value:String, deviceId:String,offline:String) {
        try! db.operation { (context, save) -> Void in
            let _object: EventTrack = try! context.new()
            _object.name = name
            _object.type = type
            _object.value = value
            _object.deviceId = deviceId
            _object.appKey = appKey
            _object.offline = offline
            _object.trackDate = Date()
            try! context.insert(_object)
            save()
        }
    }
    
    @objc func addGeoFenceEeventData(geoFenceName:String, type:String,offline:String) {
        try! db.operation { (context, save) -> Void in
            let _object: GeofenceEvents = try! context.new()
            _object.geoFenceName = geoFenceName
            _object.eventType = type
            _object.offline = offline
            _object.eventDate = Date()
            try! context.insert(_object)
            save()
        }
    }
    @objc func addBeaconEeventData(beaconName:String,beaconId:String, type:String,offline:String) {
        try! db.operation { (context, save) -> Void in
            let _object: BeaconEvent = try! context.new()
            _object.beaconName = beaconName
            _object.beaconId = beaconId
            _object.eventType = type
            _object.offline = offline
            _object.eventDate = Date()
            try! context.insert(_object)
            save()
        }
    }


    @objc func listOfScreenFlowObject() -> [ScreenFlow]{
        let sort = NSSortDescriptor(key: #keyPath(ScreenFlow.dateTime), ascending: true)
        
        let screenList =  try! db.fetch(FetchRequest<ScreenFlow>().sorted(with: sort))
        return screenList
    }

    @objc func listOfUserDetailsObject() -> [UserDetails]{
        let userList =  try! db.fetch(FetchRequest<UserDetails>())
        return userList
    }
    
    @objc func allTrackData() -> [EventTrack] {
        let sort = NSSortDescriptor(key: #keyPath(EventTrack.trackDate), ascending: true)
        
        let screenList =  try! db.fetch(FetchRequest<EventTrack>().sorted(with: sort))
        return screenList
    }
    @objc func removeEventTrackData(item: EventTrack){
        try! db.operation({ (context, save) -> Void in
            let mContext: NSManagedObjectContext = context as! NSManagedObjectContext
            do {
                let managedObject = try mContext.existingObject(with: item.objectID)
                _ = try? context.remove(managedObject)
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            }
            save()
        })
    }
    
    @objc func removeScreenDetailsFromDB(item: ScreenFlow) {
        try! db.operation({ (context, save) -> Void in
            let mContext: NSManagedObjectContext = context as! NSManagedObjectContext
            do {
                let managedObject = try mContext.existingObject(with: item.objectID)
                _ = try? context.remove(managedObject)
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            }
            save()
        })
    }
    
    @objc func removeUserDetailsFromDB(item: UserDetails) {
        
    }

}
