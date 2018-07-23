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
        //        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
    
    func createLocation(isCurrentLocation: Bool, lat: Double, lon: Double) {
        _ = Location(isCurrentLocation: isCurrentLocation, lat: lat, lon: lon)
        saveToPersistentStore()
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
