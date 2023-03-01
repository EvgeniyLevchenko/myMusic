//
//  UIImageView + Extension.swift
//  VRGArticles
//
//  Created by QwertY on 05.12.2022.
//

import UIKit

extension UIImageView {
    
    convenience init(contentMode: UIView.ContentMode, backgroundColor: UIColor = .white, cornerRadius: CGFloat = 20) {
        self.init()
        
        self.contentMode = contentMode
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.tintColor = .mainPurple()
    }
    
    convenience init(image: UIImage?, cornerRadius: CGFloat = 5.0, isShadow: Bool = false) {
        self.init()
        self.image = image
        self.layer.cornerRadius = cornerRadius
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.6
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
}
