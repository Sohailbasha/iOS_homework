import Foundation
import UIKit

struct Alert {
    
    private static func showAlert(in vc: UIViewController, with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter zipcode, city, or state"
        }
        let okayAction = UIAlertAction(title: "OK", style: .default) { (_) in }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
}
