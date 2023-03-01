//
//  SearchViewControllerBuilder.swift
//  myMusic
//
//  Created by QwertY on 28.02.2023.
//

import UIKit

class SearchViewControllerBuilder: ViewControllerBuilder {
    
    private var viewController: SearchViewController?
    private var interactor: SearchInteractor?
    private var presenter: SearchPresenter?
    private var router: SearchRouter?
    
    func produceInteractor() -> ViewControllerBuilder {
        interactor = SearchInteractor()
        return self
    }
    
    func producePresenter() -> ViewControllerBuilder {
        presenter = SearchPresenter()
        return self
    }
    
    func produceRouter() -> ViewControllerBuilder {
        router = SearchRouter()
        return self
    }
    
    func build() -> UIViewController {
        viewController = SearchViewController()
        guard let viewController = viewController else { return UIViewController() }
        viewController.interactor = interactor
        viewController.router = router
        interactor?.presenter = presenter
        presenter?.viewController = viewController
        router?.viewController = viewController
        return viewController
    }
}
