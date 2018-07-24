import Foundation
import CoreData

class LocationLogic {
    
    static let sharedInstance = LocationLogic()
    
    var locations: [LocationViewModel] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "isCurrentLocation", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let locationsArray = (try? CoreDataStack.context.fetch(request)) ?? []
        let vms = locationsArray.compactMap({LocationViewModel(location: $0)})
        return vms
    }
    
    func createLocation(isCurrentLocation: Bool, lat: Double, lon: Double) {
        _ = Location(isCurrentLocation: isCurrentLocation, lat: lat, lon: lon)
        saveToPersistentStore()
    }
    
    func updateLocation(isCurrentLocation: Bool, lat: Double, lon: Double) {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "isCurrentLocation", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isCurrentLocation == %@", NSNumber(booleanLiteral: true))
        request.predicate = predicate
        
        if let currentLocation = (try? CoreDataStack.context.fetch(request))?.first {
            currentLocation.setValue(isCurrentLocation, forKey: "isCurrentLocation")
            currentLocation.setValue(lat, forKey: "lat")
            currentLocation.setValue(lon, forKey: "lon")
            saveToPersistentStore()
        } else {
            createLocation(isCurrentLocation: isCurrentLocation, lat: lat, lon: lon)
        }
        
        
    }
    
    func delete(location: Location) {
        if let moc = location.managedObjectContext {
            moc.delete(location)
        }
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch let error {
            print("unable to save to persistent store: \(error)")
        }
    }
}
