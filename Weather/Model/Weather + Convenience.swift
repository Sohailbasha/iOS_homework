import Foundation
import CoreData

extension Weather {
    
    convenience init?(location: Location, dictionary:[String:Any], context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        guard let timeStamp = dictionary[WeatherKeys.timeStamp.rawValue] as? Int,
            let maxTemp = dictionary[WeatherKeys.maxTemp.rawValue] as? Double,
            let minTemp = dictionary[WeatherKeys.minTemp.rawValue] as? Double,
            let icon = dictionary[WeatherKeys.icon.rawValue] as? String,
            let summary = dictionary[WeatherKeys.summary.rawValue] as? String,
            let precipProbability = dictionary[WeatherKeys.precipProbability.rawValue] as? Double else { return nil }
        
        self.location = location
        self.timeStamp = Int64(timeStamp)
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.icon = icon
        self.summary = summary
        self.precipProbability = precipProbability
    }
}

enum WeatherKeys: String {
    case timeStamp = "time"
    case maxTemp = "temperatureHigh"
    case minTemp = "temperatureLow"
    case icon = "icon"
    case summary = "summary"
    case humidity = "humidity"
    case sunrise = "sunriseTime"
    case sunset = "sunsetTime"
    case precipProbability = "precipProbability"
}


struct weatherDTO {
    init?(json:[String:Any]) {
        
    }
}
