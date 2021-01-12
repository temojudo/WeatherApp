//
//  CurrentDayController.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/12/21.
//

import UIKit

class CurrentDayController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl:    UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionView()
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
        cell.backgroundColor = .yellow
        return cell
    }

}
