//
//  Updatable.swift
//  myMusic
//
//  Created by QwertY on 15.02.2023.
//

import Foundation

protocol Updatable {
    associatedtype T: Hashable
    var item: T? { get set }
    func updateWithItem(_ newItem: T)
}
