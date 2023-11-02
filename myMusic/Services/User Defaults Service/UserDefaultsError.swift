//
//  UserDefaultsError.swift
//  myMusic
//
//  Created by QwertY on 14.03.2023.
//

import Foundation

enum UserDefaultsError {
    case cannotSaveData
    case cannotFetchData
}

extension UserDefaultsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotSaveData:
            return NSLocalizedString("Can not save data!", comment: "")
        case .cannotFetchData:
            return NSLocalizedString("Can not fetch data!", comment: "")
        }
    }
}
