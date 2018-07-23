import UIKit

class WeatherDetailViewController: UIViewController {
    
    var weatherViewModel: WeatherViewModel? {
        didSet {
            imageView.image = weatherViewModel?.weatherImage()
            self.title = weatherViewModel?.dateText()
            self.maxTempLabel.text = weatherViewModel?.maxTempText
            self.minTempLabel.text = weatherViewModel?.minTempText
            self.summaryLabel.text = weatherViewModel?.summaryText
            self.precipLabel.text = weatherViewModel?.precipProbability()
        }
    }
    
    var imageView = UIImageView()
    
    var middleStackView = UIStackView()
    var innerStackView = UIStackView()
    
    var maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = #colorLiteral(red: 0.1254901961, green: 0.4705882353, blue: 0.862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var minTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = #colorLiteral(red: 0.6509803922, green: 0.768627451, blue: 0.8666666667, alpha: 1)
        return label
    }()
    
    var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = #colorLiteral(red: 0.1254901961, green: 0.4705882353, blue: 0.862745098, alpha: 1)
        return label
    }()
    
    var precipLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.1843137255, alpha: 1)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .white
   
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(middleStackView)
        
        summaryLabel.frame = .zero
        self.view.addSubview(summaryLabel)
        
        precipLabel.frame = .zero
        self.view.addSubview(precipLabel)
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        innerStackView.axis = .vertical
        innerStackView.distribution = .equalSpacing
        innerStackView.alignment = .center
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.addArrangedSubview(maxTempLabel)
        innerStackView.addArrangedSubview(minTempLabel)
        
        middleStackView.axis = .horizontal
        middleStackView.distribution = .equalSpacing
        middleStackView.alignment = .center
        middleStackView.spacing = 5
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        middleStackView.addArrangedSubview(imageView)
        middleStackView.addArrangedSubview(innerStackView)
        
        middleStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        middleStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.safeAreaInsets.top + 10).isActive = true
        
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.45).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.45).isActive = true
        
        maxTempLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        maxTempLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        minTempLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        minTempLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        innerStackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        innerStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        summaryLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: 100)
        summaryLabel.center = self.view.center

        precipLabel.frame = CGRect(x: summaryLabel.frame.minX, y: summaryLabel.frame.maxY + 10, width: self.view.frame.width - 20, height: 100)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}