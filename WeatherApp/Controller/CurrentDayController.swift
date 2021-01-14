//
//  CurrentDayController.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/12/21.
//

import UIKit

class CurrentDayController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var pageControl:    UIPageControl!
    @IBOutlet private var loader:         UIActivityIndicatorView!

    private let service     = CurrentWeatherService()
    private var weathers    = [CurrentWeatherResponse]()
    private var isLandscape = UIDevice.current.orientation.isLandscape
    
    private let weatherBackgroundColors: [UIColor] =
        [UIColor(named: "blue-gradient-end")!,
         UIColor(named: "green-gradient-end")!,
         UIColor(named: "ochre-gradient-end")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadCurrentWeather()
//        loader.startAnimating()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        getInitOrientation()
        setupCollectionView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        isLandscape = UIDevice.current.orientation.isLandscape
        collectionView.reloadData()
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
                        self.weathers.insert(weatherResponse, at: self.pageControl.currentPage)
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
        
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.frame.width * 0.7, height: collectionView.frame.height)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
    }
    
    @IBAction func addCity() {
        self.loadCurrentWeather(for: "rustavi")
        self.loadCurrentWeather(for: "london")
        self.loadCurrentWeather(for: "batumi")
        self.loadCurrentWeather(for: "tbilisi")
        self.loadCurrentWeather(for: "new york")
    }

}

extension CurrentDayController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = weathers.count
        pageControl.currentPage = 0
        return weathers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        if let weatherCell = cell as? WeatherCell {
            weatherCell.setOrientation(isLandscapeModeOn: isLandscape)
            weatherCell.setupCurrentWeatherView(weatherResponse: weathers[indexPath.row])
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
