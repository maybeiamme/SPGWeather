//
//  DetailPersistentStorageService.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

protocol DetailPersistentStorageServiceProtocol {
    /**
     Function that saves city name for successfully fetched weather.
     */
    func saveViewCity(name: String)
}

final class DetailPersistentStorageService {
    let storage: PersistentStorageManagerProtocol
    
    init(storage: PersistentStorageManagerProtocol) {
        self.storage = storage
    }
}

extension DetailPersistentStorageService: DetailPersistentStorageServiceProtocol {
    func saveViewCity(name: String) {
        storage.insert(string: name)
    }
}
