//
//  SearchInteractor.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    // MARK: - Private properties
    
    private var networkServise: Networking
    private var presenter: SearchPresentationLogic?
    
    // MARK: - Init
    
    init(networkService: Networking) {
        self.networkServise = networkService
    }
    
    // MARK: - Methods
    
    func makeRequest(request: Search.Model.Request.RequestType) {        
        switch request {
        case .some:
            presenter?.presentData(response: .some)
        case .getTracks(let searchTerm):
            networkServise.fetchData(searchText: searchTerm, of: SearchResponse.self) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.presenter?.presentData(response: .presentTracks(searchResponse: response))
                case .failure(let error):
                    self?.presenter?.presentData(response: .presentError(error: error))
                }
            }
        }
    }
    
    // MARK: - Injection
    
    func set(presenter: SearchPresentationLogic) {
        self.presenter = presenter
    }
}
