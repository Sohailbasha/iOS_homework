import UIKit

class WeatherDetailViewController: UIViewController {

    var weatherViewModel: WeatherViewModel? {
        didSet {
            imageView.image = weatherViewModel?.weatherImage()
            self.title = weatherViewModel?.dateText()
        }
    }
    
    var imageView = UIImageView()
    
    var outerStackView = UIStackView()
    var innerStackView = UIStackView()
    
    var maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont(name: "Lucida Grande", size: 25)
        label.textColor = #colorLiteral(red: 0.1254901961, green: 0.4705882353, blue: 0.862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var minTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont(name: "Lucida Grande", size: 25)
        label.textColor = #colorLiteral(red: 0.6509803922, green: 0.768627451, blue: 0.8666666667, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .white
    
        imageView.contentMode = .scaleAspectFit
        imageView.center = self.view.center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(outerStackView)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        outerStackView.axis = UILayoutConstraintAxis.horizontal
        outerStackView.distribution = UIStackViewDistribution.equalSpacing
        outerStackView.alignment = UIStackViewAlignment.center
        outerStackView.spacing = 0.0
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        outerStackView.addArrangedSubview(imageView)
        outerStackView.addArrangedSubview(innerStackView)

        outerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.safeAreaInsets.top + 10).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        
    }
    
    
}
