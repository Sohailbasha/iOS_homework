import UIKit

class WeatherDetailViewController: UIViewController {

    var weatherViewModel: WeatherViewModel? {
        didSet {
            imageView.image = weatherViewModel?.weatherImage()
        }
    }
    
    var imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.center = self.view.center
    }
    
    
    
    
}
