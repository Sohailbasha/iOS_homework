import Foundation
import CoreData

class LocationLogic {
    
    static let sharedInstance = LocationLogic()
    
    var locations: [Location] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "isCurrentLocation", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
    
    var locationVMs: [LocationViewModel] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let locations = (try? CoreDataStack.context.fetch(request))
        let locationVM = locations?.compactMap({LocationViewModel(location: $0)})
        return locationVM ?? []
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
