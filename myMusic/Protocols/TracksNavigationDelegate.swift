//
//  TracksNavigationDelegate.swift
//  myMusic
//
//  Created by QwertY on 22.02.2023.
//

import Foundation

protocol TracksNavigationDelegate: AnyObject {
    func moveToPreviousTrack() -> SearchViewModel.Cell?
    func moveToNextTrack() -> SearchViewModel.Cell?
}
