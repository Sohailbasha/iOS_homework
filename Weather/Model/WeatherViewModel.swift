import Foundation
import UIKit

struct WeatherViewModel {
    
    let weather: Weather
    let tempMaxText: String
    let tempMinText: String
    
    init(weather: Weather) {
        self.weather = weather
        self.tempMaxText = "\(weather.maxTemp)°"
        self.tempMinText = "\(weather.minTemp)°"
    }
    
}
