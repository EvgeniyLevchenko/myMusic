//
//  TrackCell.swift
//  myMusic
//
//  Created by QwertY on 15.02.2023.
//

import UIKit
import SDWebImage

// Declare a custom key for a custom `item` property.
// MARK: - Configuration State Custom Key
fileprivate extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("myMusic.TrackListCell.item")
}

// Declare an extension on the cell state struct to provide a typed property for this custom state.
// MARK: - UICellConfigurationState
private extension UICellConfigurationState {
    var item: (any TrackCellViewModel)? {
        set { self[.item] = newValue as? AnyHashable }
        get { return self[.item] as? (any TrackCellViewModel) }
    }
}

class TrackCell<T: TrackCellViewModel>: UICollectionViewListCell {
    
    // MARK: UI Elements 
    
    private let coverImageView = UIImageView(contentMode: .scaleAspectFit, backgroundColor: .systemGray5, cornerRadius: 5.0)
    private let trackNameLabel = UILabel(text: "", font: .systemFont(ofSize: 17, weight: .medium), numberOfLines: 0)
    private let artistNameLabel = UILabel(text: "", font: .systemFont(ofSize: 13, weight: .medium), textColor: .systemGray, numberOfLines: 0)
    private let collectionLabel = UILabel(text: "", font: .systemFont(ofSize: 13, weight: .medium), textColor: .systemGray, numberOfLines: 0)
    
    private var isConstraintsSet: Bool = false
    
    // MARK: - Setup View
    
    var item: T? = nil
    
    func updateWithItem(_ newItem: T) {
        guard item != newItem else { return }
        item = newItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        guard let item = self.item as? SearchViewModel.Cell else { return state }
        state.item = item
        return state
    }
    
    /// - Tag: UpdateConfiguration
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        guard let cellItem = state.item else { return }
        let string60 = cellItem.iconUrlString?.replacingOccurrences(of: "100x100", with: "60x60")
        guard let url = URL(string: string60 ?? "") else { return }
        
        coverImageView.sd_setImage(with: url)
        trackNameLabel.text = cellItem.artistName
        artistNameLabel.text = cellItem.artistName
        collectionLabel.text = cellItem.collectionName
    }
}

// MARK: - Setup Layout
extension TrackCell {
    private func setupViewsIfNeeded() {
        // We only need to do anything if we haven't already setup the views and created constraints.
        guard isConstraintsSet == false else { return }
        
        let trackInfoStackView = UIStackView(arrangedSubviews: [
            trackNameLabel,
            artistNameLabel,
            collectionLabel
        ], axis: .vertical, spacing: 2)
        
        let stackView = UIStackView(arrangedSubviews: [coverImageView, trackInfoStackView], axis: .horizontal, spacing: 12, alignment: .leading)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        isConstraintsSet = true
    }
}
