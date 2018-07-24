import UIKit
import CoreData
import CoreLocation

class LocationTableViewController: UIViewController, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        setupNavBarAndBarButtons()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self

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
    
    var delegate: LocationSelectDelegate?
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation? {
        didSet {
            if let currentLocation = self.currentLocation {
                DispatchQueue.main.async {
                    LocationLogic.sharedInstance.updateLocation(isCurrentLocation: true,
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
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    
    @objc func showAddLocationsAlert() {
        Alert.showAddLocationAlert(in: self)
    }
    
    @objc func getCurrentLocation() {
        if(isLocationPermissionGranted()) {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager.startUpdatingLocation()
        } else {
            Alert.showAuthorizationAlert(in: self)
        }
    }
    
    func isLocationPermissionGranted() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }

    
    func getPlacemark(location: Location, completion: @escaping(_ location: String) -> ()) {
        LocationGeocoder.geolocate(location: location) { (placemark, error) in
            guard let city = placemark?.locality else { return }
            guard let state = placemark?.administrativeArea else { return }
            let location = "\(city), \(state)"
            completion(location)
        }
    }
    
    func setupNavBarAndBarButtons() {
        self.title = "Locations"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(showAddLocationsAlert))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "marker"), style: .plain, target: self, action: #selector(getCurrentLocation))
    }
    
    func setupTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        self.view.addSubview(tableView)
    }

}

// MARK: - Table View Datasource / Delegate
extension LocationTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        guard let location = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            return UITableViewCell()
        }
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
    
}

// MARK: - NSFetchedResultsControllerDelegate functions
/*
 
 */
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

// MARK: - Location Delegate Methods
extension LocationTableViewController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
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
