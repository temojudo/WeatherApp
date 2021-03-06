//
//  WeatherService.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/13/21.
//

import Foundation

class WeatherService {

    private let appid = "3c9206a2fb0960a1cd4a453c99319467"
    private var components = URLComponents()

    init() {
        components.scheme = "https"
        components.host   = "api.openweathermap.org"
        components.path   = "/data/2.5/weather"
    }
    
    private func loadForecastWeatherResponse(parameters: [String: String], completion: @escaping (Result<ForecastWeatherResponse, Error>) -> ()) {
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(.failure(ServiceError(msg: "No internet connection")))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(ForecastWeatherResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(ServiceError(msg: "City with that name wasn't found!")))
                    }
                } else {
                    completion(.failure(ServiceError(msg: "City with that name wasn't found!")))
                }
            })
            task.resume()
        } else {
            completion(.failure(ServiceError(msg: "Invalid parameters")))
        }
    }
    
    private func loadCurrentWeatherResponse(parameters: [String: String], completion: @escaping (Result<CurrentWeatherResponse, Error>) -> ()) {
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(.failure(ServiceError(msg: "No internet connection")))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(CurrentWeatherResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(ServiceError(msg: "City with that name wasn't found!")))
                    }
                } else {
                    completion(.failure(ServiceError(msg: "City with that name wasn't found!")))
                }
            })
            task.resume()
        } else {
            completion(.failure(ServiceError(msg: "Invalid parameters")))
        }
    }

    func loadCurrentWeatherResponce(city: String, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> ()) {
        let parameters = [
            "appid": appid.description,
            "q":     city.description,
        ]
        
        self.loadCurrentWeatherResponse(parameters: parameters, completion: { result in
            switch result {
                case .success(let weatherResponse):
                    completion(.success(weatherResponse))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }
    
    func loadCurrentWeatherResponce(lon: Double, lat: Double, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> ()) {
        let parameters = [
            "appid": appid.description,
            "lon":   lon.description,
            "lat":   lat.description
        ]
        
        self.loadCurrentWeatherResponse(parameters: parameters, completion: { result in
            switch result {
                case .success(let weatherResponse):
                    completion(.success(weatherResponse))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }
    
    func loadForecastWeatherResponce(city: String, completion: @escaping (Result<ForecastWeatherResponse, Error>) -> ()) {
        let parameters = [
            "appid": appid.description,
            "q":     city.description,
        ]
        
        components.path = "/data/2.5/forecast"
        
        self.loadForecastWeatherResponse(parameters: parameters, completion: { result in
            switch result {
                case .success(let weatherResponse):
                    completion(.success(weatherResponse))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }
    
}

struct ServiceError: Error {
    let msg: String
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(msg, comment: "")
    }
}
