import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
        setupActivityIndicator()
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let location = self.locationViewModel {
            self.getWeatherDataFor(location: location.location)
        }
        
        if LocationLogic.sharedInstance.locations.isEmpty {
            // IF NO LOCATIONS EXIST
            performSegue(withIdentifier: "findLocationSegue", sender: self)
        } else {
            // IF LOCATIONS EXIST
            if let locationVM = locationViewModel {
                // IF VC HOLDS LOCATION (returning from detail)
                self.locationViewModel = locationVM
            } else {
                // IF VC DOES NOT HOLD LOCAITON (initially set)
                guard let locationVM = LocationLogic.sharedInstance.locations.first else { return }
                self.locationViewModel = locationVM
            }
        }
    }
    
    private let cellID = "detailCell"
    private let kCellSidePadding: CGFloat = 20
    private var activityIndicator: UIActivityIndicatorView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action:#selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.darkGray
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if let locationViewModel = locationViewModel {
            self.getWeatherDataFor(location: locationViewModel.location)
        }
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    var locationViewModel: LocationViewModel? {
        didSet {
            if let locationViewModel = locationViewModel {
                self.getWeatherDataFor(location: locationViewModel.location)
                self.setTitle(for: locationViewModel)
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
    
    @objc func locationsList() {
        let viewController = LocationTableViewController()
        viewController.delegate = self
        viewController.modalTransitionStyle = .crossDissolve
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: viewController)
        navBarOnModal.modalPresentationStyle = .overCurrentContext
        self.present(navBarOnModal, animated: true, completion: nil)
    }
    
    // Set Up Methods //
    
    func setTitle(for locationVM: LocationViewModel) {
        locationVM.getCityName(completion: { (locationName) in
            self.title = locationName
        })
    }
    
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
    }
    
    func setupNavBar() {
        self.navigationItem.largeTitleDisplayMode = .always
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "list"), style: .plain, target: self, action: #selector(locationsList))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }

}

// MARK: - Collection View Datasource, Delegate, DelegateFlowlayout
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
        return CGSize(width: UIScreen.main.bounds.width - kCellSidePadding, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = WeatherDetailViewController()
        viewController.weatherViewModel = forecast[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Location Select Delegate
extension MainViewController: LocationSelectDelegate {
    func didSelect(location: Location) {
        let locationViewModel = LocationViewModel(location: location)
        self.locationViewModel = locationViewModel
    }
}
