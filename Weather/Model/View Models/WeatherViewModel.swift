import Foundation
import UIKit

struct WeatherViewModel {
    
    let weather: Weather
    let maxTempText: String?
    let minTempText: String?
    private let timeStamp: Int?
    
    init?(weather: Weather){
        self.weather = weather
        self.maxTempText = "High \(weather.maxTemp)°"
        self.minTempText = "Low \(weather.minTemp)°"
        self.timeStamp = Int(weather.timeStamp)
    }
    
    
    func dateText() -> String {
        guard let timeStamp = self.timeStamp else { return "" }
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM dd"
//        "MMMM dd, yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func weatherImage() -> UIImage {
        guard let iconString = weather.icon else { return UIImage() }
        guard let iconImage = UIImage(named: iconString) else { return UIImage() }
        return iconImage
    }
    
}
