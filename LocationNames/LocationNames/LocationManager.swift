//
//  LocationManager.swift
//  LocationNames
//
//  Created by Anh Dinh on 3/6/21.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    static let shared = LocationManager()

    // this CLLocationManager is an object used to start and stop the delivery of location
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)? //? wtf is this
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)){
        self.completion = completion
        manager.requestWhenInUseAuthorization() // get users' permission for location
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    // the reason String is optional is that if we can't reverse the location to get the name, we give it Nil
    public func resolveLocationName(with location: CLLocation, completion: @escaping ((String?) -> Void)){
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { (placemarks, error) in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            print(place)
            
            var name = ""
            
            if let locality = place.locality{
                name += locality
            }
            
            if let adminRegion = place.administrativeArea{
                name += ", \(adminRegion)"
            }
            
            // run completion handler after we got the name
            completion("This is the name from completion handler: \(name)")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the first location from locations array (parameter)
        guard let location = locations.first else {
            return
        }
        
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
}
