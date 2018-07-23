import Foundation
import UIKit

struct LocationViewModel {
    
    let location: Location
    
    init(location: Location) {
        self.location = location
    }
    
    func getCityName(completion: @escaping(_ location: String) -> ()) {
        LocationGeocoder.geolocate(location: self.location) { (placemark, error) in
            guard let city = placemark?.locality else { return }
            guard let state = placemark?.administrativeArea else { return }
            let locationName = "\(city), \(state)"
            completion(locationName)
        }
    }
}
