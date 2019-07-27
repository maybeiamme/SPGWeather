
//
//  SearchApiRequestMock.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation
@testable import Weather

class SearchApiRequestMock: SearchApiRequestProtocol {
    var completion: ((Result<SearchApiResponse, ApiError>) -> Void)?
    var query: String?
    var nextTaskIdentifier = 1
    func request(with query: String, completion: @escaping (Result<SearchApiResponse, ApiError>) -> Void) -> Int {
        self.query = query
        self.completion = completion
        return nextTaskIdentifier
    }
    
    var cancelled = [Int]()
    func cancel(identifier taskIdentifier: Int) {
        cancelled.append(taskIdentifier)
    }
}
