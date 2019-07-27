//
//  Utilities.swift
//  WeatherUITests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//
import Foundation

struct UITest {
    static func data(for url: String) -> Data {
        switch url {
        case "https://api.worldweatheronline.com/premium/v1/search.ashx?q=Singapore&key=0434896a6994489cb6905901192607&format=json":
            return "home_search".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Singapore&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/search.ashx?q=ABC&key=0434896a6994489cb6905901192607&format=json":
            return "home_search_20response".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=La%20Pulgosa&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Los%20Llanos&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Albacete&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=La%20Torrecica&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=La%20Losilla&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Caserio%20La%20Losilla&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Salobral&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Pozo%20De%20La Pena&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Caserio%20Pozo%20De%20La%20Pena&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Casa%20Grande&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        case "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=Chinchilla%20De%20Monte%20Aragon&key=0434896a6994489cb6905901192607&format=json":
            return "detail_singapore".stub()
        default:
            return "home_search".stub()
        }
    }
}

extension String {
    func stub() -> Data {
        let plistPath = Bundle.main.path(forResource: "StubResponses", ofType: "plist")!
        let stubs = NSDictionary(contentsOfFile: plistPath) as! Dictionary<String, String>
        return stubs[self]!.data(using: .utf8)!
    }
}
