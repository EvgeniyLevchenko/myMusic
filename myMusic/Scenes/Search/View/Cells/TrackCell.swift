//
//  TrackCell.swift
//  myMusic
//
//  Created by QwertY on 15.02.2023.
//

import UIKit
import SDWebImage

final class TrackTableViewCell: UITableViewCell {
    
    // MARK: - Coding Key
    
    enum CodingKey: String {
        case tracks = "tracks"
    }
    
    // MARK: Private properties
    
    private lazy var coverImageView = UIImageView(
        contentMode: .scaleAspectFit,
        backgroundColor: .systemGray5,
        cornerRadius: 5.0
    )
    
    private lazy var trackNameLabel = UILabel(
        text: "",
        font: .systemFont(ofSize: 17, weight: .medium),
        numberOfLines: 1
    )
    
    private lazy var artistNameLabel = UILabel(
        text: "",
        font: .systemFont(ofSize: 13, weight: .medium),
        textColor: .systemGray,
        numberOfLines: 1
    )
    
    private lazy var collectionLabel = UILabel(
        text: "",
        font: .systemFont(ofSize: 13, weight: .medium),
        textColor: .systemGray,
        numberOfLines: 1
    )
    
    private lazy var addTrackButton = UIButton(
        title: "",
        image: UIImage(named: "add"),
        tintColor: .red,
        backgroundColor: .white
    )
    
    private lazy var trackInfoStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                trackNameLabel,
                artistNameLabel,
                collectionLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                coverImageView,
                trackInfoStackView
            ]
        )
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var viewModel: SearchViewModel.Cell = .init(
        trackName: "",
        collectionName: "",
        artistName: ""
    )
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Method
    
    func configure(with viewModel: SearchViewModel.Cell) {
        self.viewModel = viewModel
        
        UserDefaults.standard.fetchObjects(ofClass: SearchViewModel.Cell.self, forKey: CodingKey.tracks.rawValue) { result in
            switch result {
            case .success(let tracks):
                let hasFavourite = tracks.firstIndex(where: {
                    $0.trackName == self.viewModel.trackName && $0.artistName == self.viewModel.artistName
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
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionLabel.text = viewModel.collectionName
        let string60 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "60x60")
        guard let url = URL(string: string60 ?? "") else {
            return
        }
        coverImageView.sd_setImage(with: url)
    }
    
    // MARK: - Private methods
    
    @objc private func addTrackButtonTapped() {
        var tracksList = [SearchViewModel.Cell]()
        
        UserDefaults.standard.fetchObjects(ofClass: SearchViewModel.Cell.self, forKey: CodingKey.tracks.rawValue) { result in
            switch result {
            case .success(let data):
                tracksList = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        tracksList.insert(viewModel, at: 0)
        UserDefaults.standard.save(objects: tracksList, forKey: CodingKey.tracks.rawValue) { error in
            if let error = error {
                print(error)
            }
        }
        
        addTrackButton.isHidden = true
    }
    
    private func setupView() {
        addTrackButton.addTarget(
            self,
            action: #selector(addTrackButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func addSubviews() {
        contentView.addSubview(mainStackView)
        contentView.addSubview(addTrackButton)
    }
    
    private func setupLayout() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addTrackButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverImageView.widthAnchor.constraint(equalToConstant: 60),
            coverImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            addTrackButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addTrackButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            addTrackButton.widthAnchor.constraint(equalToConstant: 16.0),
            addTrackButton.heightAnchor.constraint(equalToConstant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: addTrackButton.leadingAnchor, constant: -12)
        ])
    }
}
