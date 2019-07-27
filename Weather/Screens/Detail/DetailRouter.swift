//
//  DetailRouter.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit

final class DetailRouter {
    static func instantiate(cityName: String) -> UIViewController {
        let networkManager = NetworkManager(session: URLSession.shared)
        let weatherApi = WeatherApiRequest(networkManager: networkManager, decoder: JSONDecoder())
        let apiService = DetailApiService(weatherApi: weatherApi)
        let persistentStorege = PersistentStorageManager(storage: UserDefaults.standard)
        let persistentStorageService = DetailPersistentStorageService(storage: persistentStorege)
        let thumbnailDownloader = ThumbnailDownloader()
        let interactor = DetailInteractor(apiService: apiService, persistentService: persistentStorageService, thumbnailDownloader: thumbnailDownloader, cityName: cityName)
        let presenter = DetailPresenter(interactor: interactor)
        interactor.set(presenter: presenter)
        let view = DetailViewController(nibName: String(describing: DetailViewController.self), bundle: Bundle.main) as DetailViewController
        presenter.set(view: view)
        view.set(presenter: presenter)
        return view
    }
}
