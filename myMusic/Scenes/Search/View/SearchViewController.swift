//
//  SearchViewController.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    // MARK: - Private properties
    
    private lazy var tracksTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .mainWhite()
        tableView.register(
            TrackTableViewCell.self,
            forCellReuseIdentifier: String(describing: TrackTableViewCell.self)
        )
        return tableView
    }()
    
    private lazy var viewModel: [SearchViewModel.Cell] = [] {
        didSet {
            tracksTableView.reloadData()
        }
    }
    
    private var interactor: SearchBusinessLogic?
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private var lastSelectedCellIndexPath: IndexPath?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .mainWhite()
        setupSearchBar()
    }
    
    // MARK: - Private methods
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.isOpaque = true
        searchController.navigationController?.navigationBar.barTintColor = .mainWhite()
    }
    
    // MARK: - Injection
    
    func set(interactor: SearchBusinessLogic) {
        self.interactor = interactor
    }
}

// MARK: - Search Bar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
        })
    }
}

// MARK: - TracksNavigationDelegate

extension SearchViewController: TracksNavigationDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = lastSelectedCellIndexPath else { return nil }
        var nextIndexPath: IndexPath
        switch isForwardTrack {
        case true:
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == viewModel.count {
                nextIndexPath.row = 0
            }
        case false:
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == 0 {
                nextIndexPath.row = viewModel.count - 1
            }
        }
        lastSelectedCellIndexPath = nextIndexPath
        return viewModel[nextIndexPath.row]
    }
    
    func moveToPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveToNextTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TrackTableViewCell.self)
        ) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        let trackViewModel = viewModel[indexPath.row]
        cell.configure(with: trackViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel[indexPath.row]
        tabBarDelegate?.maximizeTrackDetailsView(viewModel: item)
        let keyWindow = UIApplication.shared.getKeyWindow()
        let mainTabBarViewContoller = keyWindow?.rootViewController as? MainTabBarController
        mainTabBarViewContoller?.trackDetailView.delegate = self
        lastSelectedCellIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Display Logic

extension SearchViewController: SearchDisplayLogic {
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .some:
            break
        case .displayTracks(let searchViewModel):
            self.viewModel = searchViewModel.cells
        }
    }
}
