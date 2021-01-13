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

    private let service     = CurrentWeatherService()
    private var weathers    = [CurrentWeatherResponse]()
    private var isLandscape = UIDevice.current.orientation.isLandscape
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadCurrentWeather()
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
    
    private func loadCurrentWeather() {
        service.loadCurrentWeatherResponce(for: "tbilisi") { [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let weatherResponse):
                        print(weatherResponse)
                        
                    case .failure(let error):
                        print(error)
                }
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
        print("iaaaaa")
    }

}

extension CurrentDayController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        return pageControl.numberOfPages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        if let weatherCell = cell as? WeatherCell {
            weatherCell.setOrientation(isLandscapeModeOn: isLandscape)
        }
        return cell
    }

}

extension CurrentDayController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

}
