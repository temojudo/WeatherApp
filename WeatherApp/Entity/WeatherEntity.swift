//
//  WeatherEntity.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/13/21.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let coord:   Coordinate
    let weather: [Weather]
    let wind:    Wind
    let clouds:  Clouds
    let name:    String
    let main:    Temperature
    let sys:     System
}

struct ForecastWeatherResponse: Decodable {
    let list: [ForecastListItem]
    let city: City
}

struct ForecastListItem: Decodable {
    let main:        Temperature
    let weather:     [Weather]
    let fullDateStr: String
    
    let date: Date
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case main        = "main"
        case weather     = "weather"
        case fullDateStr = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        main        = try container.decode(Temperature.self, forKey: .main)
        weather     = try container.decode([Weather].self,   forKey: .weather)
        fullDateStr = try container.decode(String.self,      forKey: .fullDateStr)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'mm'-'dd'"
        
        let dateSplit = fullDateStr.split(separator: " ")
        let dateStr   = String(dateSplit[0])
        let fullTime  = String(dateSplit[1])
        
        date = dateFormatter.date(from: dateStr)!
        time = String(fullTime[..<fullTime.lastIndex(of: ":")!])
    }
}

struct City: Decodable {
    let name:    String
    let country: String
}

struct System: Decodable {
    let country: String
}

struct Coordinate: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let main:        String
    let description: String
    let iconUrlStr:  String
    
    enum CodingKeys: String, CodingKey {
        case main        = "main"
        case description = "description"
        case iconUrlStr  = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        
        let icon = try container.decode(String.self, forKey: .iconUrlStr)
        iconUrlStr = "https://openweathermap.org/img/w/\(icon).png"
    }
}

struct Temperature: Decodable {
    let temperature: Double
    let humidity:    Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humitidy    = "humidity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let kelvinOffset = 273.15
        temperature = try container.decode(Double.self, forKey: .temperature) - kelvinOffset
        humidity    = try container.decode(Double.self, forKey: .humitidy)
    }
}

struct Wind: Decodable {
    let speed:  Double
    let degree: Double
    
    enum CodingKeys: String, CodingKey {
        case speed  = "speed"
        case degree = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let meterSpeedToKmeterMultiplier = 3.6
        speed  = try container.decode(Double.self, forKey: .speed) * meterSpeedToKmeterMultiplier
        degree = try container.decode(Double.self, forKey: .degree)
    }
}

struct Clouds: Decodable {
    let cloudiness: Double
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cloudiness = try container.decode(Double.self, forKey: .cloudiness)
    }
}
