import UIKit
import CoreData

class LocationTableViewController: UIViewController, NSFetchedResultsControllerDelegate, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var delegate: LocationSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        self.view.addSubview(tableView)
        
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0,
                                                                    y: 0,
                                                                    width: UIScreen.main.bounds.width,
                                                                    height: 44))
        
        let navItem = UINavigationItem(title: "Locations");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                       target: nil,
                                       action: #selector(something))
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .search,
                                      target: nil,
                                      action: #selector(somethingElse))
        
        navItem.rightBarButtonItem = addItem
        navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
       
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
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    }
    
    @objc func something() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func somethingElse() {
        Alert.showAddLocationAlert(in: self)
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

protocol LocationSelectDelegate {
    func didSelect(location: Location)
}
