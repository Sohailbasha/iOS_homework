import Foundation

struct LocationViewModel {
    
    var location: Location
    var cityName: String
    
    init(location: Location) {
        self.location = location
        self.cityName = LocationGeocoder.locationName(location: location)
    }
}
