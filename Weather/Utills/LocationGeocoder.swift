import Foundation
import CoreLocation
import UIKit

class LocationGeocoder: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationGeocoder()
    
    
    func getLocationData(from inputString: String, vc: UIViewController) {
        CLGeocoder().geocodeAddressString(inputString) { (placemarks, error) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    print(location)
                }
                
                if let city = placemarks?.first?.locality {
                    print(city)
                }
                
                // create a city
                // TODO: Callback city and location
                
            } else {
                Alert.showLocationInputErrorAlert(in: vc, inputString: inputString)
            }
        }
    }
    
}

