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
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.startUpdatingLocation()
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
        }
        coreLocationManager.stopUpdatingLocation()
    }
    
    func updateLocationFor(cityOrZip: String, vc: UIViewController) {
        CLGeocoder().geocodeAddressString(cityOrZip) { (placemarks, error) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    print(location)
                }
                
                if let city = placemarks?.first?.locality {
                    print(city)
                }
            } else {
                Alert.showLocationInputErrorAlert(in: vc, location: cityOrZip)
            }
        }
    }
    
}

