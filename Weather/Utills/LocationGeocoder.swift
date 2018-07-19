import Foundation
import CoreLocation
import UIKit

class LocationGeocoder: NSObject, CLLocationManagerDelegate {
    
    static func getLocationData(from inputString: String, completion: @escaping (_ location: CLLocation?, _ error: Error?) -> Void) {
        CLGeocoder().geocodeAddressString(inputString) { (placemarks, error) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    completion(location, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
}

