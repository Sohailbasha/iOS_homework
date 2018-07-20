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
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Label text >"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        self.backgroundColor = .white
        self.addSubview(temperatureLabel)
        
        temperatureLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        temperatureLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
    }
    
}
