
//
//  DetailApiServiceMock.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation
@testable import Weather

class WeatherApiRequestMock: WeatherApiRequestProtocol {
    var completion: ((Result<WeatherApiResponse, ApiError>) -> Void)?
    var query: String?
    func request(with query: String, completion: @escaping (Result<WeatherApiResponse, ApiError>) -> Void) {
        self.query = query
        self.completion = completion
    }
}
