//
//  DetailInteractor.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation

/**
 Protocol that DetailPresenter will refer to.
 DetailPresenter sends message to interactor via this channel.
 */
protocol DetailInteractorInputProtocol {
    /**
     Function that request to weather api with saved city name
    */
    func requestWeather()
}

final class DetailInteractor {
    private let apiService: DetailApiServiceProtocol
    private let persistentService: DetailPersistentStorageServiceProtocol
    private let thumbnailDownloader: ThumbnailDownloaderProtocol
    private let cityName: String
    private weak var presenter: DetailInteractorOutputProtocol?
    
    init(
        apiService: DetailApiServiceProtocol,
        persistentService: DetailPersistentStorageServiceProtocol,
        thumbnailDownloader: ThumbnailDownloaderProtocol,
        cityName: String
        ) {
        self.apiService = apiService
        self.persistentService = persistentService
        self.thumbnailDownloader = thumbnailDownloader
        self.cityName = cityName
    }
    
    func set(presenter: DetailInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    private var entity: DetailEntity?
}

extension DetailInteractor: DetailInteractorInputProtocol {
    func requestWeather() {
        apiService.request(with: cityName) { [weak self] result in
            guard let self = self else {
                return
            }
            self.entity = result
            DispatchQueue.main.async {
                self.presenter?.weatherDataLoaded(entity: result)
            }
            self.downloadImage(for: result.weatherImageUrl)
            self.persistentService.saveViewCity(name: self.cityName)
        }
    }
}

extension DetailInteractor {
    private func downloadImage(for urlString: String?) {
        if let urlString = urlString,
            let url = URL(string: urlString) {
            DispatchQueue.global().async {
                let image = self.thumbnailDownloader.downsample(imageUrl: url)
                DispatchQueue.main.async {
                    guard let entity = self.entity else {
                        return 
                    }
                    self.presenter?.weatherImageLoaded(image: image, entity: entity)
                }
            }
        }
    }
}
