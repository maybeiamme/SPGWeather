//
//  NetworkManager.swift
//  Weather
//
//  Created by Shepherd on 25/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

enum Result<Success, Failure> where Failure : Error {
    case success(Success)
    case failure(Failure)
}

enum NetworkError: Error {
    case networkerror
}

protocol NetworkCancelable {
    
    /**
     Function that removes the corresponding task.
     
     - Parameter taskIdentifier: Unique identifier for task to cancel from the session that created this task.
     */
    func cancel(identifier taskIdentifier: Int)
}

protocol NetworkManagerProtocol: NetworkCancelable {
    /**
     Function that is responsible for network operation.
     
     - Parameter request: URLRequest object includes method, url, parameter, or post body.
     - Parameter completion: completion handler to be called when network request has been successfully delivered.
     - Parameter result: Result type which contains either data or error
     - Returns: Unique identifier for task from current session
     */
    func request(with request: URLRequest, completion: @escaping (_ result: Result<Data, NetworkError>) -> Void) -> Int
}

final class NetworkManager {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }
}

extension NetworkManager: NetworkManagerProtocol {
    func request(with request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) -> Int {
        // for UITEST
        if ProcessInfo.processInfo.environment["Environment"] == "UITEST" {
            completion(.success(UITest.data(for: request.url!.absoluteString)))
            return -1
        }

        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data,
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode else {
                    completion(.failure(NetworkError.networkerror))
                    return
            }
            completion(.success(data))
        }
        task.resume()
        return task.taskIdentifier
    }
    
    func cancel(identifier taskIdentifier: Int) {
        let predicate: (URLSessionTask) -> Bool = { task in
            return task.taskIdentifier == taskIdentifier
        }
        session.getAllTasks { tasks in
            tasks.first(where: predicate)?.cancel()
        }
    }
}
