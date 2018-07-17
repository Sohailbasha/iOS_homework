import UIKit

class LocationFinderViewController: UIViewController {

    var locateMeButton = UIButton()
    var enterLocationButton = UIButton()
    var stackView = UIStackView()
    
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
}

// MARK: - UI INITs
extension LocationFinderViewController {
    
    func commonInit() {
        stackView.axis  = UILayoutConstraintAxis.vertical
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
        stackView.addArrangedSubview(enterLocationButton)
    }
}

// MARK: - Helper Methods
extension LocationFinderViewController {
    func showAlert() {
        
    }
}
