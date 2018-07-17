import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    
    func getLocationData(from inputString: String, vc: UIViewController) {
        CLGeocoder().geocodeAddressString(inputString) { (placemarks, error) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    print(location)
                }
                
                if let city = placemarks?.first?.locality {
                    print(city)
                }
                
                // TODO: Callback city and location
                
            } else {
                Alert.showLocationInputErrorAlert(in: vc, inputString: inputString)
            }
        }
    }
    
}

