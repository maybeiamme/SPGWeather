//
//  Protocols.swift
//  Weather
//
//  Created by Shepherd on 28/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//
import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func array(forKey defaultName: String) -> [Any]?
}

extension UserDefaults: UserDefaultsProtocol { }

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void)
}

extension URLSession: URLSessionProtocol {}
