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
    
    public static let temperatureKey                            = "temperatureSystem"
    public static let speedKey                                  = "speedSystem"
    
    public static let backgroundColor                           = UIColor(named: "bg-gradient-end")!
    public static let weekdays: [String]                        = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
    
    
    public static let currentWeatherBackgroundColors: [UIColor] =
        [UIColor(named: "blue-gradient-end")!,
         UIColor(named: "green-gradient-end")!,
         UIColor(named: "ochre-gradient-end")!]
    
    static func kelvinString(kelvinDegree: Double) -> String {
        return String(format: "%.1fK", kelvinDegree)
    }
    
    static func kelvinToCelsiusString(kelvinDegree: Double) -> String {
        return String(format: "%.1f°C", kelvinDegree + kelvinToCelsiusOffset)
    }
    
    static func kelvinToFahrenheitString(kelvinDegree: Double) -> String {
        return String(format: "%.1f°F", (kelvinDegree + kelvinToCelsiusOffset) * celsiusToFahrenheitMultiplier + celsiusToFahrenheitOffset)
    }
    
    static func msString(msSpeed: Double) -> String {
        return String(format: "%.1f m/s", msSpeed)
    }
    
    static func msToKmhString(msSpeed: Double) -> String {
        return String(format: "%.1f km/h", msSpeed * msToKmhMultiplier)
    }
    
    static func msToMphString(msSpeed: Double) -> String {
        return String(format: "%.1f mph", msSpeed * msToMphMultiplier)
    }
    
    static func getTemperatureString(degree: Double) -> String {
        let tempSys = UserDefaults.standard.object(forKey: temperatureKey) as? Int ?? Speed.kmh.rawValue
        
        switch (tempSys) {
            case 0:
                return kelvinToCelsiusString(kelvinDegree: degree)
                
            case 1:
                return kelvinToFahrenheitString(kelvinDegree: degree)
                
            case 2:
                return kelvinString(kelvinDegree: degree)
                
            default:
                return ""
        }
    }
    
    static func getSpeedString(speed: Double) -> String {
        let speedSys = UserDefaults.standard.object(forKey: speedKey) as? Int ?? 0
        
        switch (speedSys) {
            case 0:
                return msToKmhString(msSpeed: speed)
                
            case 1:
                return msString(msSpeed: speed)
                
            case 2:
                return msToMphString(msSpeed: speed)
                
            default:
                return ""
        }
    }
    
}
