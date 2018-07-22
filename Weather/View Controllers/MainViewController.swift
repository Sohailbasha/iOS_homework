import UIKit

class MainViewController: UIViewController {

    private let cellID = "detailCell"
    let kSidePadding: CGFloat = 20
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.view.addSubview(collectionView)
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if LocationLogic.sharedInstance.locations.isEmpty {
            print("LOCATIONS IS EMPTY")
            performSegue(withIdentifier: "findLocationSegue", sender: self)
            /*
            LocationLogic.sharedInstance.createLocation(isCurrentLocation: false, lat: 40.696011, lon: -73.993286)
            */
        } else {
            print("LOCATION IS NOT EMPTY")
            guard let location = LocationLogic.sharedInstance.locations.first else { return }
            self.location = location
        }
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "list"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocationSegue" {
            // do something
        }
    }
    
    var location: Location? {
        didSet {
            
            if let location = location {
                self.getWeatherDataFor(location: location)
                LocationGeocoder.geolocate(location: location) { (placemark, error) in
                    guard let placemark = placemark else { return }
                    DispatchQueue.main.async {
                        self.title = placemark.locality!
                    }
                }
            }
            
        }
    }
    
    var forecast: [WeatherViewModel] = [] {
        didSet {
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        cv.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        return cv
    }()
    
}

// MARK: - Helper Methods

extension MainViewController {
    
    func getWeatherDataFor(location: Location) {
        WeatherLogic.sharedInstance.fetchWeatherData(for: location) { (forecast) in
            let weatherViewModels: [WeatherViewModel] = forecast.compactMap{return WeatherViewModel(weather: $0)}
            self.forecast = weatherViewModels
        }
    }
    
    func locationsList() {
        // show list of locaitons
    }

}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? WeatherCollectionViewCell
        
        let weatherViewModel = forecast[indexPath.row]
        cell?.weatherViewModel = weatherViewModel
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - kSidePadding, height: 100)
    }
}

