import Foundation
import CoreLocation

class WeatherLogic {
    
    static let sharedInstance = WeatherLogic()
    let baseURL: String = "https://api.darksky.net/forecast/41ca2cd5a5e9bd8f6a40ee15d20bf9ca/"
    // append lat + lon
    
    func fetchWeatherData(for location: Location) {
        var urlString = baseURL + "\(location.lat),\(location.lon)"
        print(urlString)
    }
    
    
    
}
