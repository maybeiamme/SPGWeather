
//
//  HomePresenter.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit

struct HomeStatusViewModel: Equatable {
    let isViewedCitiesViewHidden: Bool
    let isSearchedListViewHidden: Bool
    let isVacantStatusViewHidden: Bool
}

/**
 Protocol that HomeInteractor will weakly refer to.
 HomeInteractor sends message to presenter via this channel.
 */
protocol HomeInteractorOutputProtocol: AnyObject {
    /**
     Function should be called when network access is completed
    */
    func searchResultLoaded(results: HomeSearchedKeyword)
}

/**
 Protocol that HomeViewController will refer to.
 HomeViewController sends message to presenter via this channel.
 */
protocol HomeViewOutputProtocol {
    func viewDidLoad()
    func searchBarHasResigned()
    func searchBarHasBecomeFirstResponder()
    func typedInSearchBar(with text: String?)
    func dataSourceForCurrentStatus() -> [String]
    func sectionTitleForCurrentStatus() -> String
    func didSelectSearchedKeyword(at index: Int)
}

final class HomePresenter {
    private let interactor: HomeInteractorInputProtocol
    private let router: HomeRouterProtocol
    private weak var view: (HomeViewInputProtocol & UIViewController)?
    
    init(
        interactor: HomeInteractorInputProtocol,
        router: HomeRouterProtocol
        ) {
        self.interactor = interactor
        self.router = router
    }
    
    func set(view: (HomeViewInputProtocol & UIViewController)) {
        self.view = view
    }
    
    private var lastReceivedSearchedList: [String]?
    private var status: HomeStatusViewModel?
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func searchResultLoaded(results: HomeSearchedKeyword) {
        lastReceivedSearchedList = results.titles
        view?.reloadSearchedTableView()
    }
}

extension HomePresenter: HomeViewOutputProtocol {
    func viewDidLoad() {
        let status = viewModelWhenSearchBarHasResigned()
        self.status = status
        view?.set(status: status)
        view?.reloadViewdCitiesTableView()
    }
    
    func didSelectSearchedKeyword(at index: Int) {
        guard let cityName = interactor.cityName(for: index) else {
            return
        }
        router.navigateToWeatherView(from: view, with: cityName)
    }
    
    func searchBarHasResigned() {
        lastReceivedSearchedList = nil
        let status = viewModelWhenSearchBarHasResigned()
        self.status = status
        view?.set(status: status)
        view?.reloadViewdCitiesTableView()
    }
    
    func searchBarHasBecomeFirstResponder() {
        let status = HomeStatusViewModel(
            isViewedCitiesViewHidden: true,
            isSearchedListViewHidden: false,
            isVacantStatusViewHidden: true
        )
        self.status = status
        view?.set(status: status)
        view?.reloadSearchedTableView()
    }
    
    func typedInSearchBar(with text: String?) {
        interactor.search(with: text)
    }
    
    func dataSourceForCurrentStatus() -> [String] {
        if status?.isSearchedListViewHidden == false {
            return lastReceivedSearchedList ?? [String]()
        } else {
            return interactor.viewedCities().citiNames
        }
    }
    
    func sectionTitleForCurrentStatus() -> String {
        if status?.isSearchedListViewHidden == false {
            return "Search results"
        } else {
            return "Viewed Cities"
        }
    }
    
    private func viewModelWhenSearchBarHasResigned() -> HomeStatusViewModel {
        let isViewedCityEmpty = interactor.viewedCities().citiNames.isEmpty
        let status = HomeStatusViewModel(
            isViewedCitiesViewHidden: isViewedCityEmpty,
            isSearchedListViewHidden: true,
            isVacantStatusViewHidden: !isViewedCityEmpty
        )
        return status
    }
}
