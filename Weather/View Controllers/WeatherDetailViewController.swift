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
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = UIScreen.main.bounds.height
        view.backgroundColor = .white
        return view
    }()
    
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageView = UIImageView()
    var outerStackView = UIStackView()
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
        label.numberOfLines = 0
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
        self.view.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(outerStackView)
        
        summaryLabel.frame = .zero
        scrollView.addSubview(summaryLabel)
        
        precipLabel.frame = .zero
        scrollView.addSubview(precipLabel)
        
        setupScrolLView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupInnerStackView()
        setupOuterStackView()
       
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
        summaryLabel.sizeToFit()
        precipLabel.frame = CGRect(x: summaryLabel.frame.minX, y: summaryLabel.frame.maxY + 10, width: self.view.frame.width - 20, height: 100)
    }
    
    func setupScrolLView() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupInnerStackView() {
        innerStackView.axis = .vertical
        innerStackView.distribution = .equalSpacing
        innerStackView.alignment = .center
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.addArrangedSubview(maxTempLabel)
        innerStackView.addArrangedSubview(minTempLabel)
    }
    
    func setupOuterStackView() {
        outerStackView.axis = .horizontal
        outerStackView.distribution = .equalSpacing
        outerStackView.alignment = .center
        outerStackView.spacing = 5
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.addArrangedSubview(imageView)
        outerStackView.addArrangedSubview(innerStackView)
    }
    
    func setupConstraints() {
        
    }
    
    
}

