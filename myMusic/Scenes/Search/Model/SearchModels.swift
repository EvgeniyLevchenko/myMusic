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

class SearchViewModel: NSObject {
    enum CodingKey: String {
        case cells = "cells"
    }
    
    @objc(_TtCC7myMusic15SearchViewModel4Cell)class Cell: NSObject, NSCoding, TrackCellViewModel, Identifiable {
        enum CodingKey: String {
            case iconUrl = "iconUrl"
            case trackName = "trackName"
            case collectionName = "collectionName"
            case artistName = "artistName"
            case previewUrl = "previewUrl"
        }
        
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
        
        init(iconUrlString: String? = nil,
             trackName: String,
             collectionName: String,
             artistName: String,
             previewUrl: String? = nil) {
            self.iconUrlString = iconUrlString
            self.trackName = trackName
            self.collectionName = collectionName
            self.artistName = artistName
            self.previewUrl = previewUrl
        }
        
        required init?(coder: NSCoder) {
            iconUrlString = coder.decodeObject(forKey: CodingKey.iconUrl.rawValue) as? String? ?? ""
            trackName = coder.decodeObject(forKey: CodingKey.trackName.rawValue) as? String ?? ""
            collectionName = coder.decodeObject(forKey: CodingKey.collectionName.rawValue) as? String ?? ""
            artistName = coder.decodeObject(forKey: CodingKey.artistName.rawValue) as? String ?? ""
            previewUrl = coder.decodeObject(forKey: CodingKey.previewUrl.rawValue) as? String? ?? ""
        }
        
        func encode(with coder: NSCoder) {
            coder.encode(iconUrlString, forKey: CodingKey.iconUrl.rawValue)
            coder.encode(trackName, forKey: CodingKey.trackName.rawValue)
            coder.encode(collectionName, forKey: CodingKey.collectionName.rawValue)
            coder.encode(artistName, forKey: CodingKey.artistName.rawValue)
            coder.encode(previewUrl, forKey: CodingKey.previewUrl.rawValue)
        }
    }
    
    init(cells: [Cell]) {
        self.cells = cells
    }
    
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: CodingKey.cells.rawValue) as? [SearchViewModel.Cell] ?? []
    }
    
    let cells: [Cell]
    
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: CodingKey.cells.rawValue)
    }
}
