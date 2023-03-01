//
//  SearchModels.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Alamofire

typealias RequestType = Search.Model.Request.RequestType

enum Search {
    
    enum Model {
        struct Request {
            enum RequestType {
                case some
                case getTracks(searchTerm: String)
            }
        }
        struct Response {
            enum ResponseType {
                case some
                case presentTracks(searchResponse: SearchResponse)
                case presentError(error: Error)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case some
                case displayTracks(searchViewModel: SearchViewModel)
            }
        }
    }
    
}

struct SearchViewModel: Hashable {
    struct Cell: TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
