//
//  ApiEndpoints.swift
//  Weather
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

enum Version: String {
    case v1
}

/**
 Struct that holds all api endpoint this app can access
 */
enum ApiUrls {
    case search
    
    /**
     Function that returns corresponding compelete url for api.
     
     - Parameter version: Version for the api. default is v1.
     */
    func url(for version: Version = .v1) -> String? {
        switch self {
        case .search:
            return url(for: "search", version: version)
        }
    }
    
    private func url(for key: String, version: Version) -> String? {
        guard let baseurl = Bundle.main.configValue(for: "baseurl"),
            let endpoint = Bundle.main.configValue(for: "endpoint." + key) else {
                return nil
        }
        return baseurl + "/" + version.rawValue + endpoint
    }
}
