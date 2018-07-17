import Foundation
import CoreData

extension Location {
    
    convenience init(isCurrentLocation: Bool, lat: Double, lon: Double, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.isCurrentLocation = isCurrentLocation
        self.lat = lat
        self.lon = lon
    }
    
}
