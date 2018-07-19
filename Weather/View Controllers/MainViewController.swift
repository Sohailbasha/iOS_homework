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
    
    
    
    

    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocationSegue" {
            if let destinationVC = segue.destination as? LocationFinderViewController {
                
            }
        }
    }
    

}
