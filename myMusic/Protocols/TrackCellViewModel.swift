//
//  TrackCellViewModel.swift
//  myMusic
//
//  Created by QwertY on 19.02.2023.
//

import UIKit

protocol TrackCellViewModel: Hashable {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
    var previewUrl: String? { get }
}

