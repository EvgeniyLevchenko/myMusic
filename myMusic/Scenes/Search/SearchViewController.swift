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

private enum Section {
    case main
}

private typealias SearchDataSource = UICollectionViewDiffableDataSource<Section, SearchViewModel.Cell>
private typealias SearchDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, SearchViewModel.Cell>

class SearchViewController: UIViewController {
    
    private var dataSource: SearchDataSource!
    private var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private var lastSelectedCellIndexPath: IndexPath?
    
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    // MARK: Routing
    
    // TO DO
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .mainWhite()
        setupSearchBar()
        configureHierarchy()
        configureDataSource()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.isOpaque = true
        searchController.navigationController?.navigationBar.barTintColor = .mainWhite()
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
}

// MARK: Display Logic
extension SearchViewController: SearchDisplayLogic {
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .some:
            break
        case .displayTracks(let searchViewModel):
            reloadDataSource(with: searchViewModel.cells)
        }
    }
}

// MARK: - Collection View Layout
extension SearchViewController {
    /// - Tag: List
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func raiseCollectionView() {
        let bottomInset = 64.0
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

// MARK: - Collection View Data Source
extension SearchViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TrackCell<SearchViewModel.Cell>, SearchViewModel.Cell> { (cell, indexPath, item) in
            cell.updateWithItem(item)
        }
        
        dataSource = SearchDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SearchViewModel.Cell) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func reloadDataSource(with cells: [SearchViewModel.Cell]) {
        var snapshot = SearchDataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(cells, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Collection View Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = dataSource.snapshot().itemIdentifiers(inSection: .main)
        tabBarDelegate?.maximizeTrackDetailsView(viewModel: items[indexPath.row])
        let keyWindow = UIApplication.shared.getKeyWindow()
        let mainTabBarViewContoller = keyWindow?.rootViewController as? MainTabBarController
        mainTabBarViewContoller?.trackDetailView.delegate = self
        raiseCollectionView()
        lastSelectedCellIndexPath = indexPath
        collectionView.deselectItem(at: indexPath, animated: true)
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

// MARK: - Tracks Navigation Delegate

extension SearchViewController: TracksNavigationDelegate {
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = lastSelectedCellIndexPath else { return nil }
        let cells = dataSource.snapshot().itemIdentifiers(inSection: .main)
        var nextIndexPath: IndexPath
        switch isForwardTrack {
        case true:
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == cells.count {
                nextIndexPath.row = 0
            }
        case false:
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == 0 {
                nextIndexPath.row = cells.count - 1
            }
        }
        lastSelectedCellIndexPath = nextIndexPath
        return cells[nextIndexPath.row]
    }
    
    func moveToPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveToNextTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
    }
}
