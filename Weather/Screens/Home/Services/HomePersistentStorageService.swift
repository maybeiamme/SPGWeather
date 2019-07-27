//
//  HomePersistentStorageService.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//
import Foundation

protocol HomePersistentStorageServiceProtocol {
    /**
     Function that returns all viewd cities from database
     */
    func getViewedCities() -> HomeViewdCities
}

final class HomePersistentStorageService {
    let storage: PersistentStorageManagerProtocol
    
    init(storage: PersistentStorageManagerProtocol) {
        self.storage = storage
    }
}

extension HomePersistentStorageService: HomePersistentStorageServiceProtocol {
    func getViewedCities() -> HomeViewdCities {
        return HomeViewdCities(citiNames: storage.fetch())
    }
}
