//
//  ViewControllerBuilder.swift
//  myMusic
//
//  Created by QwertY on 28.02.2023.
//

import UIKit

protocol ViewControllerBuilder {
    func produceInteractor() -> ViewControllerBuilder
    func producePresenter() -> ViewControllerBuilder
    func produceRouter() -> ViewControllerBuilder
    func build() -> UIViewController
}
