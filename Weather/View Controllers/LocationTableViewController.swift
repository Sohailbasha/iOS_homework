import UIKit
import CoreData
import CoreLocation

class LocationTableViewController: UIViewController, NSFetchedResultsControllerDelegate, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var delegate: LocationSelectDelegate?
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation? {
        didSet {
            if let currentLocation = self.currentLocation {
                DispatchQueue.main.async {

                    LocationLogic.sharedInstance.createLocation(isCurrentLocation: true,
                                                                lat: currentLocation.coordinate.latitude,
                                                                lon: currentLocation.coordinate.longitude)
                }
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "isCurrentLocation")
        return tv
    }()
    
    let fetchedResultsController: NSFetchedResultsController<Location> = {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "isCurrentLocation", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        self.view.addSubview(tableView)
        self.title = "Locations"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showAddLocationsAlert))

        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error starting fetched results controller: \(error)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = self.view.frame
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showAddLocationsAlert() {
        self.showBasicLocationAlert(in: self, with: "Add a new location")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        guard let location = fetchedResultsController.fetchedObjects?[indexPath.row] else { return UITableViewCell() }
        getPlacemark(location: location) { (city) in
            cell.textLabel?.text = city
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        delegate?.didSelect(location: location)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let location = fetchedResultsController.fetchedObjects?[indexPath.row] {
                LocationLogic.sharedInstance.delete(location: location)
            }
        }
    }
    
    func getPlacemark(location: Location, completion: @escaping(_ location: String) -> ()) {
        LocationGeocoder.geolocate(location: location) { (placemark, error) in
            guard let city = placemark?.locality else { return }
            guard let state = placemark?.administrativeArea else { return }
            let location = "\(city), \(state)"
            completion(location)
        }
    }

}

// MARK: - NSFetchedResultsControllerDelegate functions
extension LocationTableViewController {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension LocationTableViewController: UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension LocationTableViewController {
    
    func showBasicLocationAlert(in vc: UIViewController, with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var tf: UITextField?
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter zipcode, city, or state"
            tf = textField
        }
        
        // add aciton
        let okayAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            if let text = tf?.text, !text.isEmpty {
                LocationGeocoder.getLocationData(from: text, completion: { (location, error) in
                    if let _ = error {
                        Alert.showAddLocationAlert(in: vc)
                    }
                    
                    if let location = location {
                        LocationLogic.sharedInstance.createLocation(isCurrentLocation: false, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    }
                })
            }
        }
        
        // locate aciton
        let currentLocationAction = UIAlertAction(title: "Use Current Location", style: .default) { (_) in
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.startUpdatingLocation()
            }
        }
        
        // cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        alertController.addAction(currentLocationAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
        }
        locationManager.stopUpdatingLocation()
    }
    
}

protocol LocationSelectDelegate {
    func didSelect(location: Location)
}
