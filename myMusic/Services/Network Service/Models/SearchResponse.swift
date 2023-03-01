//
//  SearchRespone.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}
