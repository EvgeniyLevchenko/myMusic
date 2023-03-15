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
    
    enum CodingKey: String {
        case tracks = "tracks"
    }
    
    // MARK: UI Elements
    private let coverImageView = UIImageView(
        contentMode: .scaleAspectFit,
        backgroundColor: .systemGray5,
        cornerRadius: 5.0
    )
    private let trackNameLabel = UILabel(
        text: "",
        font: .systemFont(ofSize: 17, weight: .medium),
        numberOfLines: 1
    )
    private let artistNameLabel = UILabel(
        text: "",
        font: .systemFont(ofSize: 13, weight: .medium),
        textColor: .systemGray,
        numberOfLines: 1
    )
    private let collectionLabel = UILabel(
        text: "",
        font: .systemFont(ofSize: 13, weight: .medium),
        textColor: .systemGray,
        numberOfLines: 1
    )
    private let addTrackButton = UIButton(
        title: "",
        image: UIImage(named: "add"),
        tintColor: .red,
        backgroundColor: .white
    )
    
    private var isConstraintsSet: Bool = false
    private var item: T? = nil
    
    // MARK: - Setup View
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtonTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButtonTarget() {
        addTrackButton.addTarget(self, action: #selector(addTrackButtonTapped), for: .touchUpInside)
        addTrackButton.addTarget(self, action: #selector(asd), for: .touchDragOutside)
    }
    
    @objc private func addTrackButtonTapped() {
        guard let item = item as? SearchViewModel.Cell else { return }
        var tracksList = [SearchViewModel.Cell]()
        
        UserDefaults.standard.fetchObjects(ofClass: SearchViewModel.Cell.self, forKey: CodingKey.tracks.rawValue) { result in
            switch result {
            case .success(let data):
                tracksList = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        tracksList.insert(item, at: 0)
        UserDefaults.standard.save(objects: tracksList, forKey: CodingKey.tracks.rawValue) { error in
            if let error = error {
                print(error)
            }
        }
        
        addTrackButton.isHidden = true
    }
    
    @objc private func asd() {
        UserDefaults.standard.fetchObjects(ofClass: SearchViewModel.Cell.self, forKey: CodingKey.tracks.rawValue) { result in
            switch result {
            case .success(let data):
                data.forEach { track in
                    print("track name: \(track.trackName)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
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
        
        UserDefaults.standard.fetchObjects(ofClass: SearchViewModel.Cell.self, forKey: CodingKey.tracks.rawValue) { result in
            switch result {
            case .success(let tracks):
                let hasFavourite = tracks.firstIndex(where: {
                    $0.trackName == self.item?.trackName && $0.artistName == self.item?.artistName
                }) != nil
                
                if hasFavourite {
                    self.addTrackButton.isHidden = true
                } else {
                    self.addTrackButton.isHidden = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        coverImageView.sd_setImage(with: url)
        trackNameLabel.text = cellItem.trackName
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
        
        let stackView = UIStackView(arrangedSubviews: [coverImageView, trackInfoStackView], axis: .horizontal, spacing: 12,alignment: .leading)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addTrackButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        contentView.addSubview(addTrackButton)
        
        NSLayoutConstraint.activate([
            addTrackButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addTrackButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            addTrackButton.widthAnchor.constraint(equalToConstant: 16.0),
            addTrackButton.heightAnchor.constraint(equalToConstant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: addTrackButton.leadingAnchor, constant: -12)
        ])
        
        isConstraintsSet = true
    }
}
