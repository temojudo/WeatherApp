//
//  CurrentDayController.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/12/21.
//

import UIKit

class CurrentDayController: UIViewController {
    
    @IBOutlet private var contentView:    UIView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var pageControl:    UIPageControl!
    @IBOutlet private var loader:         UIActivityIndicatorView!
    @IBOutlet private var addButtonLoader: UIActivityIndicatorView!
    @IBOutlet private var addButtonImageView: UIImageView!

    private let service     = CurrentWeatherService()
    private var isLandscape = UIDevice.current.orientation.isLandscape

    private static let weatherKey = "weatherCities"
    private static var weathers   = [CurrentWeatherResponse]()
    
    private let weatherBackgroundColors: [UIColor] =
        [UIColor(named: "blue-gradient-end")!,
         UIColor(named: "green-gradient-end")!,
         UIColor(named: "ochre-gradient-end")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInitOrientation()
        setupCollectionView()
        refresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCollectionViewLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        isLandscape = UIDevice.current.orientation.isLandscape
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.collectionView.scrollToItem(at: IndexPath(row: self.pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
        })
    }
    
    func getInitOrientation() {
        let screenSize = view.frame.size
        isLandscape = screenSize.height / screenSize.width < 1
    }
    
    private func loadCurrentWeather(for city: String) {
        collectionView.isHidden = true
        loader.startAnimating()
        service.loadCurrentWeatherResponce(for: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async() {
                self.loader.stopAnimating()
                switch result {
                    case .success(let weatherResponse):
                        Self.weathers.insert(weatherResponse, at: 0)
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                        
                    case .failure(let error):
                        print(error)
                }
                self.collectionView.isHidden = false
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate   = self
        collectionView.dataSource = self
                
        collectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
    }
    
    func setCollectionViewLayout() {
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.frame.width * 0.7, height: collectionView.frame.height)
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func refresh() {
        Self.weathers.removeAll()
        
        let weatherCities = UserDefaults.standard.object(forKey: Self.weatherKey) as? [String] ?? [String]()
        for city in weatherCities {
            loadCurrentWeather(for: city)
        }
    }
    
    @IBAction func addCity() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let alertController = mainStoryboard.instantiateViewController(withIdentifier: "AlertController") as? AlertController {
            alertController.delegate = self
            addButtonLoader.startAnimating()
            addButtonImageView.isHidden = true
            let backgroundImage = takeScreenshot()
            DispatchQueue.global().sync {
                let blurredBackgroundImage = self.addBlurTo(backgroundImage)
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
    
    func addBlurTo(_ image: UIImage) -> UIImage? {
        guard let ciImg = CIImage(image: image) else { return nil }
        
        let filteredImage = ciImg.applyingFilter("CIGaussianBlur")
        return UIImage(ciImage: filteredImage)
    }
    
    func takeScreenshot() -> UIImage {
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
            weatherCell.cellContentView.backgroundColor = weatherBackgroundColors[indexPath.row % weatherBackgroundColors.count]
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
        Self.weathers.insert(response, at: pageControl.currentPage)
        collectionView.reloadData()
        
        var weatherCities = UserDefaults.standard.object(forKey: Self.weatherKey) as? [String] ?? [String]()
        weatherCities.insert(response.name, at: pageControl.currentPage)
        UserDefaults.standard.set(weatherCities, forKey: Self.weatherKey)
    }
    
}
