//
//  LibraryInteractor.swift
//  myMusic
//
//  Created by QwertY on 11.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LibraryBusinessLogic {
    func makeRequest(request: Library.Model.Request.RequestType)
}

class LibraryInteractor: LibraryBusinessLogic {
    
    var presenter: LibraryPresentationLogic?
    var service: LibraryService?
    
    func makeRequest(request: Library.Model.Request.RequestType) {
        
    }
}
