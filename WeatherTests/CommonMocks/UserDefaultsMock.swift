
//
//  UserDefaultsMock.swift
//  WeatherTests
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation
@testable import Weather

class UserDefaultsMock: UserDefaultsProtocol {
    var strings: [String]?
    func set(_ value: Any?, forKey defaultName: String) {
        strings = value as? [String]
    }
    
    func array(forKey defaultName: String) -> [Any]? {
        return strings
    }
}
