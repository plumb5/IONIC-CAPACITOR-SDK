//
//  P5LoactionInfo.swift
//  Plumb5SDK
//
//  Created by Shama on 5/11/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import CoreLocation
import Foundation

protocol P5LocationDelegate: AnyObject {
    func updateLocation()
    func updateLocationForGeoFence()
}

class P5LoactionInfo: NSObject, CLLocationManagerDelegate {
    weak var delegate: P5LocationDelegate? = nil

    var updateLocationForGeofence = false
    var isLocationUpdated = false
    var locationManager: CLLocationManager = .init()
    var locality: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var countryCode: String = ""
    var lat: String = ""
    var lon: String = ""
    var zipcode: String = ""

    static let sharedInstance = P5LoactionInfo()

    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    override private init() {
        print("P5LoactionInfo has been initialized")
    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            delegate?.updateLocation()
        }
    }

    func startMonitoringRegions(regions: [[String: Any]]) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print("Location monitoring is not avaible")
            return
        }
        cancleMonitoringAllregion()
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            print("Your geotification is saved but will only be activated once you grant  permission to access the device location.")
        }

        for region in regions {
            guard
                let radius = region["Radius"] as? String,
                let latitude = region["Latitude"] as? String,
                let longitude = region["Longitude"] as? String,

                let onExit = region["EntryExist"] as? String,
                let onEntry = region["EntryExist"] as? String,
                let pushId = region["MobilePushId"] as? String,
                let GeofenceName = region["GeofenceName"] as? String
            else {
                continue
            }
            let maxRadius = min((radius as NSString).doubleValue, locationManager.maximumRegionMonitoringDistance)
            let center = CLLocationCoordinate2D(latitude: (latitude as NSString).doubleValue, longitude: (longitude as NSString).doubleValue)
            let region: CLCircularRegion = .init(center: center, radius: maxRadius, identifier: GeofenceName)
            region.notifyOnEntry = false
            region.notifyOnExit = false
            if onEntry == "1" {
                region.notifyOnEntry = true
            } else if onEntry == "2" {
                region.notifyOnExit = true
            }

            locationManager.startMonitoring(for: region)
            print("location added for monitoring " + GeofenceName)
        }
        saveAllRegions(regions: regions)
        //        let radius = min (1000.0, locationManager.maximumRegionMonitoringDistance)
        //        let center = CLLocationCoordinate2D.init(latitude: 12.8986769177163, longitude: 77.6145053444288)
        //        let region : CLCircularRegion  =  CLCircularRegion(center: center, radius: radius, identifier: "Hello Mahaveer Marvel")
        //        region.notifyOnEntry = true
        //        region.notifyOnExit = false
        //        locationManager.startMonitoring(for: region)
        //
        //        let belandur = CLLocationCoordinate2D.init(latitude: 12.926031, longitude: 77.676246)
        //        let regionbelandur : CLCircularRegion  =  CLCircularRegion(center: belandur, radius: radius, identifier: "Bye Bye Belandur!!!")
        //        regionbelandur.notifyOnEntry = false
        //        regionbelandur.notifyOnExit = true
        //        locationManager.startMonitoring(for: regionbelandur)
    }

    func saveAllRegions(regions: [[String: Any]]) {
        var items: [Data] = []
        for region in regions {
            let item = NSKeyedArchiver.archivedData(withRootObject: region)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: Constants.key_GeoLocations)
        UserDefaults.standard.synchronize()
    }

    func allGeotifications() -> [[String: Any]] {
        var regions: [[String: Any]] = []
        guard let savedItems = UserDefaults.standard.array(forKey: Constants.key_GeoLocations) else { return regions }
        for savedItem in savedItems {
            guard let region = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? [String: Any] else { continue }
            regions.append(region)
        }
        return regions
    }

    func cancleMonitoringAllregion() {
        for region in locationManager.monitoredRegions {
            if region is CLCircularRegion {
                locationManager.stopMonitoring(for: region)
            }
        }
        UserDefaults.standard.removeObject(forKey: Constants.key_GeoLocations)
        UserDefaults.standard.synchronize()
    }

    func getRegionWith(identifier: String) -> [String: Any]? {
        let regions: [[String: Any]]? = allGeotifications()
        for region in regions! {
            if region["GeofenceName"] as? String == identifier {
                return region
            }
        }
        return nil
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        isLocationUpdated = true
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.

        // manager.stopUpdatingLocation()
        lat = "\(userLocation.coordinate.latitude)"
        lon = "\(userLocation.coordinate.longitude)"
        print("user latitude = " + lat)
        print("user longitude = \(userLocation.coordinate.longitude)" + lon)

        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) // changed!!!
        if updateLocationForGeofence {
            delegate?.updateLocationForGeoFence()
            return
        }

        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, _ in

            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if placeMark != nil {
                // Address dictionary
                // print(placeMark.addressDictionary, terminator: "")

                // Location name
                if let locationName = placeMark.name as? NSString {
                    print(locationName, terminator: "")
                    self.locality = locationName as String
                }

                // Street address
                if let street = placeMark.thoroughfare as? NSString {
                    print(street, terminator: "")
                }

                // City
                if let city = placeMark.locality as? NSString {
                    print(city, terminator: "")
                    self.city = city as String
                }

                // Zip code
                if let zip = placeMark.postalCode as? NSString {
                    print(zip, terminator: "")
                    self.zipcode = zip as String
                }

                // Country
                if let country = placeMark.country as? NSString {
                    print(country, terminator: "")
                    self.country = country as String
                }

                // CountryCode
                if let country = placeMark.isoCountryCode as? NSString {
                    print(country, terminator: "")
                    self.countryCode = country as String
                }

                self.delegate?.updateLocation()
            }

        })
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        delegate?.updateLocation()
        print("Error \(error)")
    }

    func locationManager(_: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError _: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
}
