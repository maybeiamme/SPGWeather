//
//  DetailViewController.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit

/**
 Protocol that DetailPresenter will weakly refer to.
 DetailPresenter sends message to presenter via this channel.
 */
protocol DetailViewInputProtocol: AnyObject {
    /**
     Function for running network indicator
     */
    func runNetworkIndicator()
    
    /**
     Function for stopping running network indicator
     */
    func stopNetworkIndicator()
    
    /**
     Function for set corresponding view model.
    */
    func set(viewModel: DetailViewModel)
}

final class DetailViewController: UIViewController {

    private var presenter: DetailViewOutputProtocol?
    
    @IBOutlet private var networkIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var humidityTitleLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var weatherTitleLabel: UILabel!
    @IBOutlet private var weatherLabel: UILabel!
    @IBOutlet private var temperatureTitleLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func set(presenter: DetailViewOutputProtocol) {
        self.presenter = presenter
    }
}

extension DetailViewController: DetailViewInputProtocol {
    func runNetworkIndicator() {
        networkIndicatorView.startAnimating()
    }
    
    func stopNetworkIndicator() {
        networkIndicatorView.stopAnimating()
    }
    
    func set(viewModel: DetailViewModel) {
        iconImageView.image = viewModel.weatherImage
        humidityLabel.text = viewModel.humidity
        humidityTitleLabel.text = viewModel.humidityTitle
        weatherTitleLabel.text = viewModel.descriptionTitle
        weatherLabel.text = viewModel.weatherDescription
        temperatureTitleLabel.text = viewModel.temperatureTitle
        temperatureLabel.text = viewModel.temperature
    }
}
