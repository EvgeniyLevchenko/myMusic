//
//  UIApplication + Extension.swift
//  myMusic
//
//  Created by QwertY on 15.03.2023.
//

import UIKit

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return keyWindow
    }
}
