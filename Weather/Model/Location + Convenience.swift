import Foundation
import CoreData

extension Location {
    
    convenience init(locationName: String, lat: Double, lon: Double, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.locationName = locationName
        self.lat = lat
        self.lon = lon
    }
    
}
