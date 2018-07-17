import Foundation
import CoreData

extension Weather {
    /*
    convenience init(minTemp: Double, maxTemp: Double, timeStamp: Int16, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.timeStamp = timeStamp
    }
    */
    
    convenience init?(dictionary:[String:Any], context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        guard let timeStamp = dictionary[WeatherKeys.timeStamp.rawValue] as? Int16,
            let maxTemp = dictionary[WeatherKeys.maxTemp.rawValue] as? Double,
            let minTemp = dictionary[WeatherKeys.minTemp.rawValue] as? Double else { return nil }
        
        self.timeStamp = timeStamp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
}

enum WeatherKeys: String {
    case timeStamp = "time"
    case maxTemp = "temperatureHigh"
    case minTemp = "temperatureLow"
}
