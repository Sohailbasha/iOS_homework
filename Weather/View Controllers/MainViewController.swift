import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = LocationFinderViewController()
        
        if location == nil {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    var location: Location?
    var locationViewModel: LocationViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.title = self.locationViewModel?.cityName
            }
        }
    }
    
    


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocationSegue" {
            if let destinationVC = segue.destination as? LocationFinderViewController {
                destinationVC.delegate? = self
            }
        }
    }
    

}

extension MainViewController: LocationDelegate {
    func fetch(isCurrentLocaiton: Bool, lat: Double, lon: Double) {
        let locationViewModel = LocationViewModel(location: Location(isCurrentLocation: isCurrentLocaiton,
                                                                     lat: lat,
                                                                     lon: lon))
        self.locationViewModel = locationViewModel
        LocationLogic.sharedInstance.saveToPersistentStore()
    }
}

