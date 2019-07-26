//
//  Utilities.swift
//  WeatherTests
//
//  Created by Jin Hyong Park on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

class Utilities { }

extension String {
    func stub() -> Data {
        let plistPath = Bundle(for: Utilities.self).path(forResource: "StubResponses", ofType: "plist")!
        let stubs = NSDictionary(contentsOfFile: plistPath) as! Dictionary<String, String>
        return stubs[self]!.data(using: .utf8)!
    }
}
