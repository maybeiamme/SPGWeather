//
//  HomeApiService.swift
//  Weather
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

protocol HomeApiServiceProtocol {
    /**
     Function that request search to api, and receives HomeSearchedKeyword as a response.
     
     When there is an error, empty array will be returned
    */
    func search(with keyword: String, completion: @escaping (HomeSearchedKeyword) -> Void)
    
    /**
     Cancel all 'Search' requests fired by this instance.
    */
    func cancelAllPreviousSearch()
}

final class HomeApiService {
    private var searchRequests = Set<Int>()
    private let searchApi: SearchApiRequestProtocol
    
    init(searchApi: SearchApiRequestProtocol) {
        self.searchApi = searchApi
    }
}

extension HomeApiService: HomeApiServiceProtocol {
    func search(with keyword: String, completion: @escaping (HomeSearchedKeyword) -> Void) {
        let taskIdentifier = searchApi.request(with: keyword) { (result) in
            switch result {
            case .success(let response):
                completion(HomeSearchedKeyword(with: response))
            case .failure(_):
                completion(HomeSearchedKeyword(titles: [String]()))
            }
        }
        searchRequests.insert(taskIdentifier)
    }
    
    func cancelAllPreviousSearch() {
        searchRequests.forEach { searchApi.cancel(identifier: $0) }
        searchRequests.removeAll()
    }
}

extension HomeSearchedKeyword {
    init(with searchedResponse: SearchApiResponse) {
        self.init(titles: searchedResponse.results?.compactMap { $0.areaName } ?? [String]())
    }
}
