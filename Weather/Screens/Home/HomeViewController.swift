//
//  HomeViewController.swift
//  Weather
//
//  Created by Shepherd on 25/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit

/**
 Protocol that HomePresenter will weakly refer to.
 HomePresenter sends message to presenter via this channel.
 */
protocol HomeViewInputProtocol: AnyObject {
    func set(status: HomeStatusViewModel)
    func reloadSearchedTableView()
    func reloadViewdCitiesTableView()
}

final class HomeViewController: UIViewController {
    
    private var presenter: HomeViewOutputProtocol?
    
    private lazy var searchedCitiesTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return tableView
    }()
    
    private lazy var viewedCitiesTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.rowHeight = 60.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return tableView
    }()
    
    private lazy var emptyStatusView: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Nothing has been seen!", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.darkGray])
        label.backgroundColor = UIColor.white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutViews()
        presenter?.viewDidLoad()
    }
    
    private func setupView() {
        view.frame = UIScreen.main.bounds
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.white
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        view.addSubview(searchedCitiesTableView)
        view.addSubview(viewedCitiesTableView)
        view.addSubview(emptyStatusView)
    }
    
    private func layoutViews() {
        searchedCitiesTableView.translatesAutoresizingMaskIntoConstraints = false
        viewedCitiesTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStatusView.translatesAutoresizingMaskIntoConstraints = false

        // view - searchedCitiesTableView
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: searchedCitiesTableView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: searchedCitiesTableView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: searchedCitiesTableView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: searchedCitiesTableView.trailingAnchor).isActive = true

        // view - viewedCitiesTableView
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: viewedCitiesTableView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: viewedCitiesTableView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: viewedCitiesTableView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: viewedCitiesTableView.trailingAnchor).isActive = true

        // view - emptyStatusView
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: emptyStatusView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: emptyStatusView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: emptyStatusView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: emptyStatusView.trailingAnchor).isActive = true

        view.layoutIfNeeded()
    }
    
    func set(presenter: HomeViewOutputProtocol) {
        self.presenter = presenter
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            presenter?.searchBarHasBecomeFirstResponder()
            presenter?.typedInSearchBar(with: searchController.searchBar.text)
        } else {
            presenter?.searchBarHasResigned()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.dataSourceForCurrentStatus().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        guard let presenter = presenter else { return cell }
        cell.textLabel?.text = presenter.dataSourceForCurrentStatus()[indexPath.row]
        return cell
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectSearchedKeyword(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let presenter = presenter else { return "" }
        return presenter.sectionTitleForCurrentStatus()
    }
}

extension HomeViewController: HomeViewInputProtocol {
    func set(status: HomeStatusViewModel) {
        searchedCitiesTableView.isHidden = status.isSearchedListViewHidden
        viewedCitiesTableView.isHidden = status.isViewedCitiesViewHidden
        emptyStatusView.isHidden = status.isVacantStatusViewHidden
    }
    
    func reloadSearchedTableView() {
        searchedCitiesTableView.reloadData()
    }
    
    func reloadViewdCitiesTableView() {
        viewedCitiesTableView.reloadData()
    }
}
