import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(in vc: UIViewController, with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter zipcode, city, or state"
        }
        let okayAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func showEnterLocationAlert(in vc: UIViewController, with title: String, message: String? = nil) {
        self.showBasicAlert(in: vc, with: title, message: message)
    }
}
