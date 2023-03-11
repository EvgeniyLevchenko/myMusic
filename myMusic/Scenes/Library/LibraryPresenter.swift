//
//  LibraryPresenter.swift
//  myMusic
//
//  Created by QwertY on 11.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LibraryPresentationLogic {
    func presentData(response: Library.Model.Response.ResponseType)
}

class LibraryPresenter: LibraryPresentationLogic {
    weak var viewController: LibraryDisplayLogic?
    
    func presentData(response: Library.Model.Response.ResponseType) {
        
    }
}
