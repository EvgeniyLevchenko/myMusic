//
//  SearchHeader.swift
//  myMusic
//
//  Created by QwertY on 19.02.2023.
//

import UIKit

class SearchHeader: UICollectionReusableView {
    private let label = UILabel()
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
    
    func configure(with items: [Any]) {
        if items.isEmpty {
            let text = "Please enter a seacrh term..."
            label.text = text
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
