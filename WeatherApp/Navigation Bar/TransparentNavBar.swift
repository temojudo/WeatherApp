//
//  TransparentNavBar.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/12/21.
//

import UIKit

class TransparentNavBar: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let appearece = UINavigationBarAppearance()
        appearece.configureWithTransparentBackground()
        appearece.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.compactAppearance    = appearece
        navigationBar.standardAppearance   = appearece
        navigationBar.scrollEdgeAppearance = appearece
    }
    
}
