import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    var weatherViewModel: WeatherViewModel? {
        didSet {
            if let vm = weatherViewModel {
                maxTempLabel.text = vm.maxTempText
                minTempLabel.text = vm.minTempText
                dateLabel.text = vm.dateText()
                iconImageView.image = vm.weatherImage()
            }
        }
    }
    
    var stackView = UIStackView()
    var maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont(name: "Lucida Grande", size: 5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var minTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont(name: "Lucida Grande", size: 5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont(name: "Lucida Grande", size: 5)
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.6509803922, green: 0.768627451, blue: 0.8666666667, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupViews() {
        self.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.4705882353, blue: 0.862745098, alpha: 1)
        self.layer.cornerRadius = 10
        setupRightStack()
        setupImageView()
        setupLeftLabel()
    }
    
}
// MARK: - Setup Funcs
extension WeatherCollectionViewCell {
    func setupRightStack() {
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 0.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(maxTempLabel)
        stackView.addArrangedSubview(minTempLabel)
        self.addSubview(stackView)
        
        maxTempLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        maxTempLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        minTempLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        minTempLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    func setupLeftLabel() {
        self.addSubview(dateLabel)
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
    }
    
    func setupImageView() {
        self.addSubview(iconImageView)
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
