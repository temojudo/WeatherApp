//
//  UIImage+Extension.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/20/21.
//

import UIKit

extension UIImage {
    
    func blur() -> UIImage? {
        guard let ciImg = CIImage(image: self) else { return nil }
        
        let filteredImage = ciImg.applyingFilter("CIGaussianBlur")
        return UIImage(ciImage: filteredImage)
    }
    
}
