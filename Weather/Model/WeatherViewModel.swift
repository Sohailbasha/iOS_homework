import Foundation
import UIKit

struct WeatherViewModel {
    
    let weather: Weather
    let maxTempText: String?
    let minTempText: String?
    
    init?(weather: Weather){
        self.weather = weather
        self.maxTempText = "\(weather.maxTemp)°"
        self.minTempText = "\(weather.minTemp)°"
    }
    
}
