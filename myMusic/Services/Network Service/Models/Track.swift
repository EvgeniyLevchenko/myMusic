//
//  Track.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//

import Foundation

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
}

extension Track: Hashable {
    
}
