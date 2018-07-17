import Foundation

class LocationLogic {
    
    static let sharedInstance = LocationLogic()
    
    var locations: [Location] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
    
    func createLocation(isCurrentLocation: Bool, lat: Double, lon: Double) {
        _ = Location(isCurrentLocation: isCurrentLocation, lat: lat, lon: lon)
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
