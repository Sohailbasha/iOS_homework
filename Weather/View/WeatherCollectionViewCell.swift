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
            }
        }
    }
    
    var stackView = UIStackView()
    var maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var minTempLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        self.backgroundColor = .white
        setupRightStack()
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
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
    }
}
