//
//  Common.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/23/21.
//

import Foundation
import UIKit

class Common {

    static func kelvinString(kelvinDegree: Double) -> String {
        return String(format: "%.1fK", kelvinDegree)
    }

    static func kelvinToCelsiusString(kelvinDegree: Double) -> String {
        return String(format: "%.1f°C", kelvinDegree + Constants.kelvinToCelsiusOffset)
    }

    static func kelvinToFahrenheitString(kelvinDegree: Double) -> String {
        return String(format: "%.1f°F", (kelvinDegree + Constants.kelvinToCelsiusOffset) * Constants.celsiusToFahrenheitMultiplier + Constants.celsiusToFahrenheitOffset)
    }

    static func msString(msSpeed: Double) -> String {
        return String(format: "%.1f m/s", msSpeed)
    }

    static func msToKmhString(msSpeed: Double) -> String {
        return String(format: "%.1f km/h", msSpeed * Constants.msToKmhMultiplier)
    }

    static func msToMphString(msSpeed: Double) -> String {
        return String(format: "%.1f mph", msSpeed * Constants.msToMphMultiplier)
    }

    static func getTemperatureString(degree: Double) -> String {
        let tempSys = UserDefaults.standard.object(forKey: Constants.temperatureKey) as? Int ?? Constants.Temperature.celsius.rawValue
        
        switch (tempSys) {
            case Constants.Temperature.celsius.rawValue:
                return kelvinToCelsiusString(kelvinDegree: degree)
                
            case Constants.Temperature.fahrenheit.rawValue:
                return kelvinToFahrenheitString(kelvinDegree: degree)
                
            case Constants.Temperature.kelvin.rawValue:
                return kelvinString(kelvinDegree: degree)
                
            default:
                return ""
        }
    }

    static func getSpeedString(speed: Double) -> String {
        let speedSys = UserDefaults.standard.object(forKey: Constants.speedKey) as? Int ?? Constants.Speed.kmh.rawValue
        
        switch (speedSys) {
            case Constants.Speed.kmh.rawValue:
                return msToKmhString(msSpeed: speed)
                
            case Constants.Speed.ms.rawValue:
                return msString(msSpeed: speed)
                
            case Constants.Speed.mph.rawValue:
                return msToMphString(msSpeed: speed)
                
            default:
                return ""
        }
    }
    
    
    static func speedDegreeToDirection(deg: Double) -> String {
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

}
