//
//  Constants.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/22/21.
//

import Foundation
import UIKit

class Constants {
    
    enum Speed: Int {
        case kmh = 0
        case ms  = 1
        case mph = 2
    }
    
    enum Temperature: Int {
        case celsius    = 0
        case fahrenheit = 1
        case kelvin     = 2
    }
    
    public static let kelvinToCelsiusOffset                     = -273.15
    public static let celsiusToFahrenheitMultiplier             = 1.8
    public static let celsiusToFahrenheitOffset                 = 32.0
    
    public static let msToKmhMultiplier                         = 3.6
    public static let msToMphMultiplier                         = 2.237
    
    public static let cityCountryDelimiter                      = ", "
    public static let temperatureWeatherDelimiter               = " | "
    public static let cloudinessDimension                       = " %"
    public static let humidityDimension                         = " mm"
    
    public static let temperatureKey                            = "temperatureSystem"
    public static let speedKey                                  = "speedSystem"
    public static let weatherKey                                = "weatherCities"
    
    public static let checkedImage                              = UIImage(systemName: "checkmark.circle.fill")
    public static let uncheckedImage                            = UIImage(systemName: "circle")
    
    public static let backgroundColor                           = UIColor(named: "bg-gradient-end")!
    public static let weekdays: [String]                        = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
    
    public static let currentWeatherBackgroundColors: [UIColor] =
        [UIColor(named: "blue-gradient-end")!,
         UIColor(named: "green-gradient-end")!,
         UIColor(named: "ochre-gradient-end")!]
    
}
