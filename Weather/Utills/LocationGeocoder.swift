import Foundation
import CoreLocation
import UIKit

class LocationGeocoder: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationGeocoder()
    
    
    func getLocationData(from inputString: String, vc: UIViewController, completion: @escaping (_ location: CLLocation) -> Void) {
        CLGeocoder().geocodeAddressString(inputString) { (placemarks, error) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    completion(location)
                }
            } else {
                Alert.showLocationInputErrorAlert(in: vc, inputString: inputString)
            }
        }
    }
    
}

