//
//  HomeRouter.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit

protocol HomeRouterProtocol {
    func navigateToWeatherView(from: UIViewController?, with cityName: String)
}

final class HomeRouter {
    static func instantiate() -> UIViewController {
        let networkManager = NetworkManager(session: URLSession.shared)
        let searchApi = SearchApiRequest(networkManager: networkManager, decoder: JSONDecoder())
        let apiService = HomeApiService(searchApi: searchApi)
        let persistentStorege = PersistentStorageManager(storage: UserDefaults.standard)
        let persistentStorageService = HomePersistentStorageService(storage: persistentStorege)
        let interactor = HomeInteractor(apiService: apiService, persistentService: persistentStorageService)
        let presenter = HomePresenter(interactor: interactor, router: HomeRouter())
        interactor.set(presenter: presenter)
        let view = HomeViewController()
        presenter.set(view: view)
        view.set(presenter: presenter)
        return view
    }
}

extension HomeRouter: HomeRouterProtocol {
    func navigateToWeatherView(from: UIViewController?, with cityName: String) {
        let viewController = DetailRouter.instantiate(cityName: cityName)
        from?.navigationController?.pushViewController(viewController, animated: true)
    }
}
