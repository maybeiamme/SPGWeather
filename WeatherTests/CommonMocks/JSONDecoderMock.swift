
//
//  JSONDecoderMock.swift
//  WeatherTests
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation
@testable import Weather

enum JSONDecoderMockError: Error {
    case error
}

class JSONDecoderMock: JSONDecoderProtocol {
    var decoded: Data?
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if decoded == nil {
            throw JSONDecoderMockError.error
        } else {
            return try! JSONDecoder().decode(type, from: decoded!)
        }
    }
}
