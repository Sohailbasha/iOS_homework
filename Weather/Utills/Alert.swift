import Foundation
import UIKit

struct Alert {
    
    // ALERTS FOR ERRORS //
    
    static func showEnterLocationAlert(in vc: UIViewController) {
        self.showBasicLocationAlert(in: vc, with: "Enter a location", message: "To recieve up-to-date weather forecasts")
    }
    
    static func showAddLocationAlert(in vc: UIViewController) {
        self.showBasicLocationAlert(in: vc, with: "Add a new location")
    }
    
    static func showLocationInputErrorAlert(in vc: UIViewController, inputString: String) {
        self.showErrorAlert(in: vc, with: "Unable to find \(inputString)")
    }
    
    static func requestAuthorizationAlert(in vc: UIViewController) {
        self.showErrorAlert(in: vc, with: "Please allow app to use location data in settings")
    }
    

    private static func showBasicLocationAlert(in vc: UIViewController, with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var tf: UITextField?
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter zipcode, city, or state"
            tf = textField
        }
        
        let okayAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            if let text = tf?.text, !text.isEmpty {
                LocationGeocoder.getLocationData(from: text, completion: { (location, error) in
                    if let _ = error {
                        Alert.showAddLocationAlert(in: vc)
                    }
                    
                    if let location = location {
                        let inputLocation = Location(isCurrentLocation: false,
                                                     lat: location.coordinate.latitude,
                                                     lon: location.coordinate.longitude)
                        print(inputLocation)
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    private static func showErrorAlert(in vc: UIViewController, with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}



