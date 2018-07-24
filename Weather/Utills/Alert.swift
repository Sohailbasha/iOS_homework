import Foundation
import UIKit

struct Alert {
    
    // Enter Location
    static func showEnterLocationAlert(in vc: UIViewController) {
        self.showBasicLocationAlert(in: vc, with: "Enter a location", message: "To recieve up-to-date weather forecasts")
    }
    
    // Add Location
    static func showAddLocationAlert(in vc: UIViewController) {
        self.showBasicLocationAlert(in: vc, with: "Add a new location")
    }
    
    // Wrong input error
    static func showLocationInputErrorAlert(in vc: UIViewController, inputString: String) {
        self.showErrorAlert(in: vc, with: "Unable to find \(inputString)")
    }
    
    // Request authorization (if you haven't yet accepted)
    static func showAuthorizationAlert(in vc: UIViewController) {
        self.authorizationAlert(vc: vc)
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
                        LocationLogic.sharedInstance.createLocation(isCurrentLocation: false, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    private static func authorizationAlert(vc: UIViewController) {
        let alertController = UIAlertController(title: "Enable location services", message: "We require your current location while you use this feature.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let changeSettingsAction = UIAlertAction(title: "Change Settings", style: .default) { (_) in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(changeSettingsAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    private static func showErrorAlert(in vc: UIViewController, with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}



