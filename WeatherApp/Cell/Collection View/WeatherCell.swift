//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/13/21.
//

import UIKit
import Foundation

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet public  var cellContentView:      UIView!
    @IBOutlet private var stackView:            UIStackView!
    @IBOutlet private var weatherImageView:         UIImageView!
    @IBOutlet private var cityLabel:            UILabel!
    @IBOutlet private var tempLabel:            UILabel!
    @IBOutlet private var cloudinessValueLabel: UILabel!
    @IBOutlet private var humidityValueLabel:   UILabel!
    @IBOutlet private var windSpeedValueLabel:  UILabel!
    @IBOutlet private var windDirValueLabel:    UILabel!
    
    private let meterSpeedToKmeterMultiplier = 3.6
    private let kelvinOffset = 273.15
    private let cornerRadius = CGFloat(25)
    
    private func speedDegreeToDirection(deg: Double) -> String {
        if deg < 22.5 || deg >= 337.5 {
            return "N"
        } else if deg >= 22.5 && deg < 67.5 {
            return "NW"
        } else if deg >= 67.5 && deg < 112.5 {
            return "W"
        } else if deg >= 112.5 && deg < 157.5 {
            return "SW"
        } else if deg >= 157.5 && deg < 202.5 {
            return "S"
        } else if deg >= 202.5 && deg < 247.5 {
            return "SE"
        } else if deg >= 247.5 && deg < 292.5 {
            return "E"
        } else if deg >= 292.5 && deg < 337.5 {
            return "NE"
        }
        
        return "~"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContentView.layer.cornerRadius = cornerRadius
    }
    
    func setupCurrentWeatherView(weatherResponse: CurrentWeatherResponse) {
        let celsius = String(format: "%.1f°C", weatherResponse.main.temp - kelvinOffset)
        let urlStr  = "https://openweathermap.org/img/w/\(weatherResponse.weather[0].icon).png"
        let speed   = String(format: "%.1f", weatherResponse.wind.speed * meterSpeedToKmeterMultiplier)
        
        weatherImageView.downloadImage(urlString: urlStr)
        cityLabel.text = weatherResponse.name + ", " + weatherResponse.sys.country
        tempLabel.text = celsius + " | " + weatherResponse.weather[0].main
        
        cloudinessValueLabel.text = weatherResponse.clouds.all.description + " %"
        humidityValueLabel.text   = weatherResponse.main.humidity.description + " mm"
        windSpeedValueLabel.text  = speed + " km/h"
        windDirValueLabel.text    = speedDegreeToDirection(deg: weatherResponse.wind.deg)
    }
    
    func setOrientation(isLandscapeModeOn: Bool) {
        stackView.axis = isLandscapeModeOn ? .horizontal : .vertical
    }

}
