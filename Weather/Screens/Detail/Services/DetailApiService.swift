//
//  DetailApiService.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//
import Foundation

protocol DetailApiServiceProtocol {
    /**
     Function that request detail weather to api, and receives HomeSearchedKeyword as a response.
     
     When there is an error, entity with nil values will be returned
     */
    func request(with keyword: String, completion: @escaping (DetailEntity) -> Void)
}

final class DetailApiService {
    private let weatherApi: WeatherApiRequestProtocol
    
    init(weatherApi: WeatherApiRequestProtocol) {
        self.weatherApi = weatherApi
    }
}

extension DetailApiService: DetailApiServiceProtocol {
    func request(with keyword: String, completion: @escaping (DetailEntity) -> Void) {
        weatherApi.request(with: keyword) { (result) in
            switch result {
            case .success(let response):
                completion(DetailEntity(with: response))
            case .failure(_):
                completion(DetailEntity(temperature: nil,
                                        weatherDescription: nil,
                                        humidity: nil,
                                        weatherImageUrl: nil))
            }
        }
    }
}

extension DetailEntity {
    init(with searchedResponse: WeatherApiResponse) {
        self.init(temperature: searchedResponse.currentCondition?.temperature,
                  weatherDescription: searchedResponse.currentCondition?.weatherDescription,
                  humidity: searchedResponse.currentCondition?.humidity,
                  weatherImageUrl: searchedResponse.currentCondition?.weatherImageUrl)
    }
}
