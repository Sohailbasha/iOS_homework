import Foundation

class LocationLogic {
    
    static let sharedInstance = LocationLogic()
    
    func createLocation(name: String, lat: Double, lon: Double) {
        
        _ = Location(locationName: name, lat: lat, lon: lon)
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
