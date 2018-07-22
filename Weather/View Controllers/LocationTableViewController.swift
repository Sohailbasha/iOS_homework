import UIKit
import CoreData

class LocationTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objvc = LocationTableViewController()
        let aObjNavi = UINavigationController(rootViewController: objvc)

        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0,
                                                                    y: 0,
                                                                    width: UIScreen.main.bounds.width,
                                                                    height: 44))
        
        self.title = "SomeTitle"
        let navItem = UINavigationItem(title: "SomeTitle");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                       target: nil, action: #selector(something));
        
        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        self.view.addSubview(navBar)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error starting fetched results controller: \(error)")
        }
    }
    
    @objc func something() {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    let fetchedResultsController: NSFetchedResultsController<Location> = {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "isCurrentLocation", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        guard let location = fetchedResultsController.fetchedObjects?[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = "\(location.lat), \(location.lon)"
        return cell
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
