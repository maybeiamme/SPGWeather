
//
//  URLSessionMock.swift
//  WeatherTests
//
//  Created by Jin Hyong Park on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation
@testable import Weather

class URLSessionDataTaskMock: URLSessionDataTask {
    var _taskIdentifier: Int?
    override var taskIdentifier: Int {
        return _taskIdentifier ?? -1
    }
    override func resume() {
        
    }
    var _isCanceled: Bool?
    override func cancel() {
        _isCanceled = true
    }
}

class URLSessionMock: URLSessionProtocol {
    var desiredTaskIdentifier: Int?
    var sessions = [AnyHashable: URLSessionDataTaskMock]()
    
    func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void) {
        completionHandler(Array(sessions.values))
    }
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        let task = URLSessionDataTaskMock()
        task._taskIdentifier = desiredTaskIdentifier
        sessions[desiredTaskIdentifier] = task
        return task
    }
}
