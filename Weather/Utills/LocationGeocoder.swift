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
    
    static func geolocate(location: Location, completion: @escaping (CLPlacemark?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.lat, longitude: location.lon)) { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }

}

