import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    func authorizeLocaiton(in vc: CLLocationManagerDelegate) {
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = vc
        
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            coreLocationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = CLLocation(latitude: location.coordinate.latitude,
                                         longitude: location.coordinate.longitude)
            print(currentLocation?.coordinate.latitude)
        }
        coreLocationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocationName() {
        let geocoder = CLGeocoder()
        guard let currentLocation = currentLocation else {
            return }
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                print("error reverse geocoding: \(error)")
            }
            
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    
                    if let city = pm.locality {
                        LocationLogic.sharedInstance.createLocation(name: city,
                                                                    lat: currentLocation.coordinate.latitude,
                                                                    lon: currentLocation.coordinate.longitude)
                    }
                }
            }
        }
    }
    
}

