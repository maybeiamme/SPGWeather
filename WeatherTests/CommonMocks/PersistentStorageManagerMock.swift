//
//  PersistentStorageManagerMock.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation
@testable import Weather

class PersistentStorageManagerMock: PersistentStorageManagerProtocol {
    var inserted = [String]()
    func insert(string: String) {
        inserted.append(string)
    }
    
    func fetch() -> [String] {
        return inserted
    }
}
