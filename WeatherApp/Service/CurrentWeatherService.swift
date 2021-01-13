//
//  CurrentWeatherService.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/13/21.
//

import Foundation

class CurrentWeatherService {

    private let appid = "3c9206a2fb0960a1cd4a453c99319467"
    private var components = URLComponents()

    init() {
        components.scheme = "https"
        components.host   = "api.openweathermap.org"
        components.path   = "/data/2.5/weather"
    }

    func loadCurrentWeatherResponce(for city: String, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> ()) {
        let parameters = [
            "appid": appid.description,
            "q":     city.description,
        ]
        
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(CurrentWeatherResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(ServiceError.noData))
                }
            })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParameters))
        }
    }
    
}

enum ServiceError: Error {
    case noData
    case invalidParameters
}
