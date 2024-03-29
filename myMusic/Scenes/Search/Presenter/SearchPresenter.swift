//
//  SearchPresenter.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    
    // MARK: - Private properties
    
    private weak var viewController: SearchDisplayLogic?
    
    // MARK: - Methods
    
    func presentData(response: Search.Model.Response.ResponseType) {
        switch response {
        case .some:
            break
        case .presentTracks(let searchResults):
            let cells = searchResults.results.map { track in
                cellViewModel(from: track)
            }
            
            let searchViewModel = SearchViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayTracks(searchViewModel: searchViewModel))
        case .presentError(let error):
            print(error)
        }
    }
    
    // MARK: - Private methods
    
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        return SearchViewModel.Cell.init(
            iconUrlString: track.artworkUrl100,
            trackName: track.trackName,
            collectionName: track.collectionName ?? "",
            artistName: track.artistName,
            previewUrl: track.previewUrl
        )
    }
    
    // MARK: - Injection
    
    func set(viewController: SearchDisplayLogic) {
        self.viewController = viewController
    }
}
