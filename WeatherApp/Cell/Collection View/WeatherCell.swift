//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/13/21.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet private var stackView:       UIStackView!
    @IBOutlet private var cellContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContentView.layer.cornerRadius = 25
    }
    
    func setOrientation(isLandscapeModeOn: Bool) {
        stackView.axis = isLandscapeModeOn ? .horizontal : .vertical
    }

}
