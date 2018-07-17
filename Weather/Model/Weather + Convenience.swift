import Foundation
import CoreData

extension Weather {
    
    convenience init(averageTemp: Int, minTemp: Int, maxTemp: Int, timeStamp: Int, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.averageTemp = averageTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.timeStamp = timeStamp
    }
}
