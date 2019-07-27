//
//  HomeInteractor.swift
//  Weather
//
//  Created by Shepherd 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

protocol HomeInteractorInputProtocol {
    func search(with keyword: String?)
    func viewedCities() -> HomeViewdCities
}

final class HomeInteractor {
    private let apiService: HomeApiServiceProtocol
    private let persistentService: HomePersistentStorageServiceProtocol
    private weak var presenter: HomeInteractorOutputProtocol?
    
    init(
        apiService: HomeApiServiceProtocol,
        persistentService: HomePersistentStorageServiceProtocol
        ) {
        self.apiService = apiService
        self.persistentService = persistentService
    }
    
    func set(presenter: HomeInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    private var searchTask: DispatchWorkItem?
}

extension HomeInteractor: HomeInteractorInputProtocol {
    func search(with keyword: String?) {
        guard let keyword = keyword,
            keyword.count > 1 else {
//                presenter?.searchResultLoaded(results: HomeSearchedKeyword(titles: [String]()))
                return
        }
        apiService.cancelAllPreviousSearch()
        if searchTask?.isCancelled == false {
            searchTask?.cancel()
        }
        let task = DispatchWorkItem { [weak self] in
            self?.apiService.search(with: keyword, completion: { (result) in
                DispatchQueue.main.async {
                    self?.presenter?.searchResultLoaded(results: result)
                }
            })
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: task)
        searchTask = task
    }
    
    func viewedCities() -> HomeViewdCities {
        return persistentService.getViewedCities()
    }
}
