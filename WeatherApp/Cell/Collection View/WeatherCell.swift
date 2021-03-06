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
    @IBOutlet private var weatherImageView:     UIImageView!
    @IBOutlet private var cityLabel:            UILabel!
    @IBOutlet private var tempLabel:            UILabel!
    @IBOutlet private var cloudinessValueLabel: UILabel!
    @IBOutlet private var humidityValueLabel:   UILabel!
    @IBOutlet private var windSpeedValueLabel:  UILabel!
    @IBOutlet private var windDirValueLabel:    UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContentView.layer.cornerRadius = 25
    }
    
    func setupCurrentWeatherView(weatherResponse: CurrentWeatherResponse) {
        let temperature = Common.getTemperatureString(degree: weatherResponse.main.temperature)
        let speed       = Common.getSpeedString(speed: weatherResponse.wind.speed)
        let countryName = Locale.current.localizedString(forRegionCode: weatherResponse.sys.country) ?? weatherResponse.sys.country
        
        weatherImageView.downloadImage(urlString: weatherResponse.weather[0].iconUrlStr)
        cityLabel.text = weatherResponse.name + Constants.cityCountryDelimiter + countryName
        tempLabel.text = temperature + Constants.temperatureWeatherDelimiter + weatherResponse.weather[0].main
        
        cloudinessValueLabel.text = weatherResponse.clouds.cloudiness.description + Constants.cloudinessDimension
        humidityValueLabel.text   = weatherResponse.main.humidity.description + Constants.humidityDimension
        windSpeedValueLabel.text  = speed
        windDirValueLabel.text    = Common.speedDegreeToDirection(deg: weatherResponse.wind.degree)
    }
    
    func setOrientation(isLandscapeModeOn: Bool) {
        stackView.axis = isLandscapeModeOn ? .horizontal : .vertical
    }

}
