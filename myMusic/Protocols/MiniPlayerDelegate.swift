//
//  MiniPlayerDelegate.swift
//  myMusic
//
//  Created by QwertY on 05.03.2023.
//

import Foundation

protocol MiniPlayerDelegate: AnyObject {
    func playPauseTrack()
    func nextTrack()
}
