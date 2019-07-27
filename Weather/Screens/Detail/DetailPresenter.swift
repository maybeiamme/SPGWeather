//
//  DetailPresenter.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import Foundation
import UIKit


/**
 Protocol that DetailInteractor will weakly refer to.
 DetailInteractor sends message to presenter via this channel.
 */
protocol DetailInteractorOutputProtocol: AnyObject {
    /**
     Function should be called when weather data load is finished
     */
    func weatherDataLoaded(entity: DetailEntity)
    
    /**
     Function should be called when icon image load is finished
     */
    func weatherImageLoaded(image: UIImage?, entity: DetailEntity)
}

struct DetailViewModel: Equatable {
    let temperatureTitle: String
    let descriptionTitle: String
    let humidityTitle: String
    let iconTitle: String
    let temperature: String?
    let weatherDescription: String?
    let humidity: String?
    let weatherImage: UIImage?
    
    init(
        temperatureTitle: String = "Temperature",
        descriptionTitle: String = "Description",
        humidityTitle: String = "Humidity",
        iconTitle: String = "Icon",
        temperature: String?,
        weatherDescription: String?,
        humidity: String?,
        weatherImage: UIImage?
        ) {
        self.temperatureTitle = temperatureTitle
        self.descriptionTitle = descriptionTitle
        self.humidityTitle = humidityTitle
        self.iconTitle = iconTitle
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.humidity = humidity
        self.weatherImage = weatherImage
    }
}

/**
 Protocol that DetailViewController will refer to.
 DetailViewController sends message to presenter via this channel.
 */
protocol DetailViewOutputProtocol {
    func viewDidLoad()
}

final class DetailPresenter {
    private let interactor: DetailInteractorInputProtocol
    private weak var view: DetailViewInputProtocol?
    
    init(
        interactor: DetailInteractorInputProtocol
        ) {
        self.interactor = interactor
    }
    
    func set(view: DetailViewInputProtocol) {
        self.view = view
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func weatherImageLoaded(image: UIImage?, entity: DetailEntity) {
        let viewModel = DetailViewModel(
            temperature: entity.temperature,
            weatherDescription: entity.weatherDescription,
            humidity: entity.humidity,
            weatherImage: image
        )
        view?.set(viewModel: viewModel)
    }
    
    func weatherDataLoaded(entity: DetailEntity) {
        let viewModel = DetailViewModel(
            temperature: entity.temperature,
            weatherDescription: entity.weatherDescription,
            humidity: entity.humidity,
            weatherImage: nil
        )
        view?.set(viewModel: viewModel)
        view?.stopNetworkIndicator()
    }
}

extension DetailPresenter: DetailViewOutputProtocol {
    func viewDidLoad() {
        interactor.requestWeather()
        view?.runNetworkIndicator()
    }
}
