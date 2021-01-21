//
//  WeatherEntity.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/13/21.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let coord:   Coordinate
    let weather: [Weather]
    let wind:    Wind
    let clouds:  Clouds
    let name:    String
    let main:    Temperature
    let sys:     System
}

struct ForecastWeatherResponse: Codable {
    let list: [ForecastListItem]
    let city: City
}

struct ForecastListItem: Codable {
    let main:    Temperature
    let weather: [Weather]
    let dt_txt:  String
}

struct City: Codable {
    let name:    String
    let country: String
}

struct System: Codable {
    let country: String
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let main:        String
    let description: String
    let icon:        String
}

struct Temperature: Codable {
    let temp:     Double
    let humidity: Double
}

struct Wind: Codable {
    let speed: Double
    let deg:   Double
}

struct Clouds: Codable {
    let all: Double
}
