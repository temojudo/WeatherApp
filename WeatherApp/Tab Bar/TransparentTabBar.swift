//
//  TransparentTabBar.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/12/21.
//

import UIKit

class TransparentTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let appearece = UITabBarAppearance()
        appearece.configureWithTransparentBackground()

        tabBar.standardAppearance = appearece
    }
    
}
