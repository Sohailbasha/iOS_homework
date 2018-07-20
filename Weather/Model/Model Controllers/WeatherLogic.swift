import Foundation
import CoreLocation

class WeatherLogic {
    
    static let sharedInstance = WeatherLogic()
    let baseURL: String = "https://api.darksky.net/forecast/41ca2cd5a5e9bd8f6a40ee15d20bf9ca/"

    
    func fetchWeatherData(for location: Location, completion: @escaping (_ forecast: [Weather]) -> Void) {
        guard let url = URL(string: baseURL + "\(location.lat),\(location.lon)") else {
            return
        }
        
        NetworkController.performRequest(for: url, httpMethod: .get) { (data, error) in
            if let _ = error {
                print("error getting weather data for location")
            }
            
            guard let data = data else {
                return }
            
            guard let serializedData = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any] else {
                completion([])
                return
            }
            
            guard let feedDictionary = serializedData["daily"] as? [String:Any] else {
                completion([])
                return
            }
            
            guard let weatherDataDictionary = feedDictionary["data"] as? [[String:Any]] else {
                completion([])
                return
            }
            
            let forecast = weatherDataDictionary.compactMap{ Weather(location: location, dictionary: $0) }

            completion(forecast)
        }
    }
    
    
    
}
