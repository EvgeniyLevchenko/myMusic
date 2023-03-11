//
//  LibraryViewController.swift
//  myMusic
//
//  Created by QwertY on 11.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LibraryDisplayLogic: AnyObject {
    func displayData(viewModel: Library.Model.ViewModel.ViewModelData)
}

class LibraryViewController: UIViewController{
    
    var interactor: LibraryBusinessLogic?
    var router: (NSObjectProtocol & LibraryRoutingLogic)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = LibraryInteractor()
        let presenter             = LibraryPresenter()
        let router                = LibraryRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}

extension LibraryViewController: LibraryDisplayLogic {
    func displayData(viewModel: Library.Model.ViewModel.ViewModelData) {
        
    }
}
