import UIKit
import CoreLocation

class LocationFinderViewController: UIViewController, CLLocationManagerDelegate {

    var locateMeButton = UIButton()
    var enterLocationButton = UIButton()
    var stackView = UIStackView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        
        self.commonInit()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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

// MARK: - Helper Methods
extension LocationFinderViewController {
    
    @objc func showAlert() {
        Alert.showEnterLocationAlert(in: self)
        // callbacks lat/lon/city name
    }
    
    @objc func fetchLocation() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Location Manager Methods
extension LocationFinderViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            Alert.requestAuthorizationAlert(in: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
           print(location)
            // create and callback a location object
            
        }
        locationManager.stopUpdatingLocation()
    }
}









