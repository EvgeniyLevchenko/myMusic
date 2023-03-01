//
//  UILabel + Extension.swift
//  myChat
//
//  Created by QwertY on 12.08.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20(), textColor: UIColor = .label, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
