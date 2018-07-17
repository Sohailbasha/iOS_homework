import UIKit

class LocationFinderViewController: UIViewController {

    fileprivate var locateMeButton: UIButton!
    fileprivate var enterLocationButton: UIButton!
    fileprivate var stackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locateMeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        enterLocationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.view.addSubview(stackView)
        print("HELLO WORLD")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        locateMeButton.setTitle("LOCATE ME", for: .normal)
        locateMeButton.setTitleColor(.white, for: .normal)
        locateMeButton.backgroundColor = .black
        locateMeButton.sizeToFit()
        
        enterLocationButton.setTitle("ENTER LOCATION", for: .normal)
        enterLocationButton.setTitleColor(.blue, for: .normal)
        enterLocationButton.sizeToFit()
        
        stackView.addArrangedSubview(locateMeButton)
        stackView.addArrangedSubview(enterLocationButton)
    }
    
    
    

}
