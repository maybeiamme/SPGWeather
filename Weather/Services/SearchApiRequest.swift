//
//  SearchApiRequest.swift
//  Weather
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case wrongurl
    case unabletoaccess
    case parseerror
    case systemerror
}

struct SearchApiResponse: Decodable, Equatable {
    let results: [SearchApiResponseResult]?
    
    enum CodingKeys: String, CodingKey {
        case search_api
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let search_api = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .search_api)
        results = try search_api.decode([SearchApiResponseResult].self, forKey: .result)
    }
    
    init(results: [SearchApiResponseResult]?) {
        self.results = results
    }
}

struct SearchApiResponseResult: Decodable, Equatable {
    let areaName: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case areaName
        case country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedAreaName = try container.decode([[String:String]].self, forKey: .areaName)
        areaName = decodedAreaName.first?["value"]
        let decodedCountry = try container.decode([[String:String]].self, forKey: .country)
        country = decodedCountry.first?["value"]
    }
    
    init(
        areaName: String?,
        country: String?
        ) {
        self.areaName = areaName
        self.country = country
    }
}

protocol SearchApiRequestProtocol: NetworkCancelable {
    /**
     Function that is responsible retrieving search result.
     
     - Parameter completion: completion handler to be called when api request has been successfully delivered.
     - Parameter result: Json parsed SearchApiResponse object
     */
    func request(with query: String, completion: @escaping (_ result: Result<SearchApiResponse, ApiError>) -> Void) -> Int
}

protocol JSONDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: JSONDecoderProtocol {}

final class SearchApiRequest {
    private let networkManager: NetworkManagerProtocol
    private let decoder: JSONDecoderProtocol
    
    init(
        networkManager: NetworkManagerProtocol,
        decoder: JSONDecoderProtocol
        ) {
        self.networkManager = networkManager
        self.decoder = decoder
    }
}

extension SearchApiRequest: SearchApiRequestProtocol {
    func cancel(identifier taskIdentifier: Int) {
        networkManager.cancel(identifier: taskIdentifier)
    }
    
    func request(with query: String, completion: @escaping (Result<SearchApiResponse, ApiError>) -> Void) -> Int {
        guard let urlString = ApiUrls.search.url(for: .v1),
            var urlComponents = URLComponents(string: urlString),
            let apikey = Bundle.main.configValue(for: "apikey") else {
                completion(.failure(ApiError.wrongurl))
                return -1
        }
        let queryItems = [URLQueryItem(name: "q", value: query), URLQueryItem(name: "key", value: apikey), URLQueryItem(name: "format", value: "json")]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(ApiError.wrongurl))
            return -1
        }
        let request = URLRequest(url: url)
        return networkManager.request(with: request) { [weak self] (result) in
            guard let self = self else {
                completion(.failure(ApiError.systemerror))
                return
            }
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(SearchApiResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(ApiError.parseerror))
                }
            case .failure(_):
                completion(.failure(ApiError.unabletoaccess))
            }
        }
    }
}

