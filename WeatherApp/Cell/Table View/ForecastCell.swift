//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/21/21.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet var weatherImageView:        UIImageView!
    @IBOutlet var timeLabel:               UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var temperatureLabel:        UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
