import UIKit
import CoreLocation

class LocationFinderViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.commonInit()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    var locateMeButton = UIButton()
    var enterLocationButton = UIButton()
    var stackView = UIStackView()
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation? {
        didSet {
            if let currentLocation = self.currentLocation {
                DispatchQueue.main.async {
                    LocationLogic.sharedInstance.createLocation(isCurrentLocation: true,
                                                                lat: currentLocation.coordinate.latitude,
                                                                lon: currentLocation.coordinate.longitude)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - Helper Methods
extension LocationFinderViewController {
    
    @objc func showAlert() {
        self.showInputLocationAlert(with: "Enter a location")
    }
    
    @objc func fetchLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
    }
    
    func showInputLocationAlert(with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var tf: UITextField?
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter zipcode, city, or state"
            tf = textField
        }
        let okayAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            if let text = tf?.text, !text.isEmpty {
                LocationGeocoder.getLocationData(from: text, completion: { (cllocation, error) in
                    if let _ = error {
                        Alert.showAddLocationAlert(in: self)
                    }
                    if let coreLocation = cllocation {
                        LocationLogic.sharedInstance.createLocation(isCurrentLocation: false,
                                                                    lat: coreLocation.coordinate.latitude,
                                                                    lon: coreLocation.coordinate.longitude)
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Location Manager Methods
extension LocationFinderViewController {
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

// MARK: - UI INITs
extension LocationFinderViewController {
    
    func commonInit() {
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 10.0
        
        self.initLocateMeButton()
        self.initEnterLocationButton()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
    }
    
    func initLocateMeButton() {
        locateMeButton.backgroundColor = .black
        locateMeButton.setTitle("LOCATE ME", for: .normal)
        locateMeButton.layer.cornerRadius = 5
        locateMeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        locateMeButton.setTitleColor(.white, for: .normal)
        locateMeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        locateMeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locateMeButton.showsTouchWhenHighlighted = true
        locateMeButton.addTarget(self, action: #selector(fetchLocation), for: .touchUpInside)
        stackView.addArrangedSubview(locateMeButton)
    }
    
    func initEnterLocationButton() {
        enterLocationButton.setTitle("ENTER LOCATION", for: .normal)
        enterLocationButton.setTitleColor(.blue, for: .normal)
        enterLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        enterLocationButton.sizeToFit()
        enterLocationButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        enterLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        enterLocationButton.showsTouchWhenHighlighted = true
        enterLocationButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        stackView.addArrangedSubview(enterLocationButton)
    }
}








