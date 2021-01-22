//
//  CurrentDayController.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/12/21.
//

import UIKit
import CoreLocation

class CurrentDayController: UIViewController {
    
    @IBOutlet private var contentView:        UIView!
    @IBOutlet private var collectionView:     UICollectionView!
    @IBOutlet private var pageControl:        UIPageControl!
    @IBOutlet private var loader:             UIActivityIndicatorView!
    @IBOutlet private var addButtonLoader:    UIActivityIndicatorView!
    @IBOutlet private var addButtonImageView: UIImageView!
    @IBOutlet private var errorPageView:      UIView!
    @IBOutlet private var reloadButton:       UIButton!
    @IBOutlet private var dismissButton:      UIButton!
    
    private let locationManager    = CLLocationManager()
    private let service            = WeatherService()
    private var isLandscape        = UIDevice.current.orientation.isLandscape
    private var shouldRotate       = false
    private var errorWeatherCities = [String]()
    private var group              = DispatchGroup()
    
    private static let weatherKey = "weatherCities"
    private static var weathers   = [CurrentWeatherResponse]()
    private static var currentWeather: String?
    
    override var shouldAutorotate: Bool {
        return shouldRotate
    }
    
    static func currentWeatherCity() -> String? {
        return currentWeather
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !errorPageView.isHidden || pageControl.numberOfPages == 0 {
            Self.currentWeather = nil
        } else {
            Self.currentWeather = Self.weathers[pageControl.currentPage].name + ", " + Self.weathers[pageControl.currentPage].sys.country
        }
    }
    
    private func forceLoadError() {
        var weatherCities = UserDefaults.standard.object(forKey: Self.weatherKey) as? [String] ?? [String]()
        weatherCities.append("dnsjnasl")
        UserDefaults.standard.set(weatherCities, forKey: Self.weatherKey)
    }
    
    private func setupButtonsCornerRadius() {
        reloadButton.layer.cornerRadius  = 10
        dismissButton.layer.cornerRadius = 10
    }
    
    private func getCurrentCoordinates() {
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.set([String](), forKey: Self.weatherKey)
//        forceLoadError()
        
        getInitOrientation()
        setupCollectionView()
        setupButtonsCornerRadius()
        getCurrentCoordinates()
        
        refresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCollectionViewLayout()
        shouldRotate = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard shouldRotate else { return }
        
        isLandscape = UIDevice.current.orientation.isLandscape
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.collectionView.scrollToItem(at: IndexPath(row: self.pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
        })
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let cell = gestureRecognizer.location(in: collectionView)

        guard
            let indexPath = collectionView.indexPathForItem(at: cell),
            indexPath.row == pageControl.currentPage
        else { return }
        
        let cityName = Self.weathers[pageControl.currentPage].name + ", " + Self.weathers[pageControl.currentPage].sys.country
        let alert    = UIAlertController(title: "Delete Weather?", message: "\(cityName) will be deleted", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { _ in
                    Self.weathers.remove(at: self.pageControl.currentPage)
                    self.collectionView.reloadData()
                    
                    var weatherCities = UserDefaults.standard.object(forKey: Self.weatherKey) as? [String] ?? [String]()
                    weatherCities.remove(at: weatherCities.firstIndex(of: cityName)!)
                    UserDefaults.standard.set(weatherCities, forKey: Self.weatherKey)
                }
            )
        )

        present(alert, animated: true, completion: nil)
    }
    
    private func getInitOrientation() {
        let screenSize = view.frame.size
        isLandscape = screenSize.height / screenSize.width < 1
    }
    
    private func loadCurrentWeather(for city: String) {
        group.enter()
        service.loadCurrentWeatherResponce(city: city) { result in
            switch result {
                case .success(let weatherResponse):
                    Self.weathers.append(weatherResponse)
                    
                case .failure( _):
                    self.errorWeatherCities.append(city)
            }
            self.group.leave()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        setupLongGestureRecognizerOnCollection()
        
        collectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
    }
    
    private func setCollectionViewLayout() {
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.frame.width * 0.7, height: collectionView.frame.height)
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func refresh() {
        Self.weathers.removeAll()
        errorWeatherCities.removeAll()
        errorPageView.isHidden = true
        
        let weatherCities = UserDefaults.standard.object(forKey: Self.weatherKey) as? [String] ?? [String]()
        
        collectionView.isHidden = true
        loader.startAnimating()
        
        for city in weatherCities {
            loadCurrentWeather(for: city)
        }
        
        group.notify(queue: .main, execute: {
            if self.errorWeatherCities.isEmpty {
                self.loader.stopAnimating()
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            } else {
                self.errorPageView.isHidden = false
            }
        })
    }
    
    @IBAction func dismissErrors() {
        var weatherCities = [String]()
        for response in Self.weathers {
            weatherCities.append(response.name + ", " + response.sys.country)
        }
        
        UserDefaults.standard.set(weatherCities, forKey: Self.weatherKey)
        refresh()
    }
    
    @IBAction func addCity() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let alertController = mainStoryboard.instantiateViewController(withIdentifier: "AlertController") as? AlertController {
            alertController.delegate = self
            addButtonLoader.startAnimating()
            addButtonImageView.isHidden = true
            let backgroundImage = takeScreenshot()
            DispatchQueue.global(qos: .userInitiated).sync {
                let blurredBackgroundImage = backgroundImage.blur()
                DispatchQueue.main.async {
                    alertController.setBackgroundImage(image: blurredBackgroundImage)
                    self.addButtonLoader.stopAnimating()
                    self.addButtonImageView.isHidden = false
                }
            }
            
            alertController.modalPresentationStyle = .overFullScreen
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func openSettings() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let settingsController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsController") as? SettingsController {
            settingsController.delegate = self
            settingsController.modalPresentationStyle = .overFullScreen
            present(settingsController, animated: true, completion: nil)
        }
    }
    
    private func getIndexInWeathers(name: String) -> Int? {
        for i in 0 ..< Self.weathers.count {
            if name == Self.weathers[i].name {
                return i
            }
        }
        
        return nil
    }
    
    private func takeScreenshot() -> UIImage {
        if let layer = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.layer {
            UIGraphicsBeginImageContext(layer.frame.size)
            if let context = UIGraphicsGetCurrentContext() {
                layer.render(in: context)
            }
        }
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

}

extension CurrentDayController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = Self.weathers.count
        return Self.weathers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        if let weatherCell = cell as? WeatherCell {
            weatherCell.setOrientation(isLandscapeModeOn: isLandscape)
            weatherCell.setupCurrentWeatherView(weatherResponse: Self.weathers[indexPath.row])
            weatherCell.cellContentView.backgroundColor = Constants.currentWeatherBackgroundColors[indexPath.row % Constants.currentWeatherBackgroundColors.count]
        }
        return cell
    }
    
}

extension CurrentDayController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let point = view.convert(collectionView.center, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        pageControl.currentPage = indexPath?.row ?? 0
    }
    
}

extension CurrentDayController: AddCityDelegate {
    
    func cityAddedSuccessfully(_ sender: AlertController, response: CurrentWeatherResponse) {
        var weatherCities = UserDefaults.standard.object(forKey: Self.weatherKey) as? [String] ?? [String]()
        
        if let index = getIndexInWeathers(name: response.name) {
            pageControl.currentPage = index
            self.collectionView.scrollToItem(at: IndexPath(row: self.pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            Self.weathers.insert(response, at: self.pageControl.currentPage)
            collectionView.isHidden = true
            loader.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
                self.loader.stopAnimating()
            })
            
            weatherCities.insert(response.name + ", " + response.sys.country, at: pageControl.currentPage)
            UserDefaults.standard.set(weatherCities, forKey: Self.weatherKey)
        }
    }
    
}

extension CurrentDayController: SettingsDelegate {
    
    func settingsChanged(_ sender: SettingsController) {
        collectionView.reloadData()
    }
    
}

extension CurrentDayController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        
        service.loadCurrentWeatherResponce(lon: coordinate.longitude, lat: coordinate.latitude, completion: { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let weatherResponse):
                        self.cityAddedSuccessfully(AlertController(), response: weatherResponse)
                        
                    case .failure( _):
                        break
                }
            }
        })
    }
    
}
