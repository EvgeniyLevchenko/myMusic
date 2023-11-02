//
//  SearchViewControllerAssembly.swift
//  myMusic
//
//  Created by QwertY on 28.02.2023.
//

import UIKit

class SearchViewControllerAssembly: Presentable {
    
    // MARK: - Private properties
    
    private var delegate: MainTabBarControllerDelegate
    
    // MARK: - Init
    
    init(delegate: MainTabBarControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    func toPresent() -> UIViewController {
        let networkService = NetworkService.shared
        let interactor = SearchInteractor(networkService: networkService)
        let viewController = SearchViewController()
        let presenter = SearchPresenter()
        viewController.tabBarDelegate = delegate
        viewController.set(interactor: interactor)
        interactor.set(presenter: presenter)
        presenter.set(viewController: viewController)
        return viewController
    }
}
