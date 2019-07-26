//
//  Bundle+Keypath.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

extension Bundle {
    func configValue(for keypath: String) -> String? {
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: plistPath) as? [String:Any] else {
                return nil
        }
        return keypath.split(separator: ".")
            .map { String($0) }
            .reduce(config) { (prev, next) -> Any? in
            guard var mutablePrev = prev as? [String: Any] else {
                return nil
            }
            return mutablePrev[next]
        } as? String
    }
}
