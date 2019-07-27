//
//  PersistentStorageManager.swift
//  Weather
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

protocol PersistentStorageManagerProtocol {
    /**
     Function that inserts string to the persistent storage
     */
    func insert(string: String)
    
    /**
     Function that returns stored data from persistent stoage
     */
    func fetch() -> [String]
}

final class PersistentStorageManager {
    private static let RecentSearchKeyword = "RecentSearchKeyword"
    private let storage: UserDefaultsProtocol
    private let semaphore = DispatchSemaphore(value: 1)
    
    init(storage: UserDefaultsProtocol) {
        self.storage = storage
    }
}

extension PersistentStorageManager: PersistentStorageManagerProtocol {
    func insert(string: String) {
        semaphore.wait()
        // filter out string from saved data and insert string at the very first element
        let modified = [string] + fetch().filter { $0 != string }
        // then only save 0 to min(modified.count, 10) strings, in order to retain only 10 keywords
        let toBeSaved = Array(modified[0..<min(modified.count, 10)])
        storage.set(toBeSaved, forKey: PersistentStorageManager.RecentSearchKeyword)
        semaphore.signal()
    }
    
    func fetch() -> [String] {
        return storage.array(forKey: PersistentStorageManager.RecentSearchKeyword) as? [String] ?? [String]()
    }
}
