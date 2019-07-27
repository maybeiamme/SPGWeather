//
//  WeatherApiRequest.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

struct WeatherApiResponse: Decodable, Equatable {
    let currentCondition: WeatherApiCurrentCondition?
    
    enum CodingKeys: String, CodingKey {
        case data
        case current_condition
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        currentCondition = (try data.decode([WeatherApiCurrentCondition].self, forKey: .current_condition)).first
    }
    
    init(currentCondition: WeatherApiCurrentCondition?) {
        self.currentCondition = currentCondition
    }
}

struct WeatherApiCurrentCondition: Decodable, Equatable {
    let temperature: String?
    let weatherDescription: String?
    let humidity: String?
    let weatherImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case temp_C
        case weatherIconUrl
        case weatherDesc
        case humidity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try container.decode(String.self, forKey: .temp_C)
        let decodedIconUrl = try container.decode([[String:String]].self, forKey: .weatherIconUrl)
        weatherImageUrl = decodedIconUrl.first?["value"]
        let decodedDescription = try container.decode([[String:String]].self, forKey: .weatherDesc)
        weatherDescription = decodedDescription.first?["value"]
        humidity = try container.decode(String.self, forKey: .humidity)
    }
    
    init(
        temperature: String?,
        weatherDescription: String?,
        humidity: String?,
        weatherImageUrl: String?
        ) {
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.humidity = humidity
        self.weatherImageUrl = weatherImageUrl
    }
}


protocol WeatherApiRequestProtocol {
    /**
     Function that is responsible retrieving detail result.
     
     - Parameter completion: completion handler to be called when api request has been successfully delivered.
     - Parameter result: Json parsed DetailApiResponse object
     */
    func request(with query: String, completion: @escaping (_ result: Result<WeatherApiResponse, ApiError>) -> Void)
}

final class WeatherApiRequest {
    private let networkManager: NetworkManagerProtocol
    private let decoder: JSONDecoderProtocol
    
    init(
        networkManager: NetworkManagerProtocol,
        decoder: JSONDecoderProtocol
        ) {
        self.networkManager = networkManager
        self.decoder = decoder
    }
}

extension WeatherApiRequest: WeatherApiRequestProtocol {
    func request(with query: String, completion: @escaping (Result<WeatherApiResponse, ApiError>) -> Void) {
        guard let urlString = ApiUrls.weather.url(for: .v1),
            var urlComponents = URLComponents(string: urlString),
            let apikey = Bundle.main.configValue(for: "apikey") else {
                completion(.failure(ApiError.wrongurl))
                return
        }
        let queryItems = [URLQueryItem(name: "q", value: query), URLQueryItem(name: "key", value: apikey), URLQueryItem(name: "format", value: "json")]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(ApiError.wrongurl))
            return
        }
        let request = URLRequest(url: url)
        let _ = networkManager.request(with: request) { [weak self] (result) in
            guard let self = self else {
                completion(.failure(ApiError.systemerror))
                return
            }
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(WeatherApiResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(ApiError.parseerror))
                }
            case .failure(_):
                completion(.failure(ApiError.unabletoaccess))
            }
        }
    }
}

