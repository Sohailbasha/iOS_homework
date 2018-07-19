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
    
    static func locationName(location: Location) -> String {
        var locaitonName = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location.lat, longitude: location.lon)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let locality = placemarks?.first?.locality {
                   locaitonName = locality
                }
            } else {
                locaitonName = ""
            }
        }
        return locaitonName
    }
    
}

