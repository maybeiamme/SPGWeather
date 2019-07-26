//
//  NetworkManagerMock.swift
//  WeatherTests
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//
import Foundation

@testable import Weather

class NetworkManagerMock: NetworkManagerProtocol {
    var completion: ((Result<Data, NetworkError>) -> Void)?
    var currentTaskIdenfier = 1
    var request: URLRequest?
    
    func request(with request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) -> Int {
        self.completion = completion
        self.request = request
        return currentTaskIdenfier
    }
    
    var removedTaskIdentifier: Int?
    func cancel(identifier taskIdentifier: Int) {
        removedTaskIdentifier = taskIdentifier
    }
}
