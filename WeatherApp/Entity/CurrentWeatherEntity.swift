//
//  CurrentWeatherEntity.swift
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
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let main: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

struct Clouds: Codable {
    let all: Double
}
