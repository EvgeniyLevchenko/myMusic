//
//  MiniPlayerView.swift
//  myMusic
//
//  Created by QwertY on 05.03.2023.
//

import UIKit
import AVKit

class MiniPlayerView: UIView {
    
    // MARK: UI Elements
    
    private let borderView = UIView()
    private let coverImageView = UIImageView(
        image: UIImage(systemName: "music.note"),
        cornerRadius: 5.0,
        isShadow: true)
    private let trackNameLabel = UILabel(
        text: "Track Title",
        font: .systemFont(ofSize: 17, weight: .medium)
    )
    private let playPauseButton = UIButton(
        title: "",
        image: UIImage(named: "pause"),
        tintColor: .darkText,
        backgroundColor: .mainWhite()
    )
    private let nextTrackButton = UIButton(
        title: "",
        image: UIImage(named: "right"),
        tintColor: .darkText,
        backgroundColor: .mainWhite()
    )
    
    weak var delegate: MiniPlayerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup View
extension MiniPlayerView {
    private func setupView() {
        setupBorderView()
        addButtonsTargets()
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        trackNameLabel.text = viewModel.trackName
        let stringUrl = viewModel.iconUrlString
        guard let url = URL(string: stringUrl ?? "") else { return }
        coverImageView.sd_setImage(with: url)
    }
    
    func setState(playerState: AVPlayer.TimeControlStatus) {
        switch playerState {
        case .paused:
            let playImage = UIImage(named: "play")
            playPauseButton.setImage(playImage, for: .normal)
        case .playing:
            let pauseImage = UIImage(named: "pause")
            playPauseButton.setImage(pauseImage, for: .normal)
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
    }
    
    private func setupBorderView() {
        borderView.backgroundColor = .systemGray5
    }
    
    private func addButtonsTargets() {
        playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        nextTrackButton.addTarget(self, action: #selector(playNextTrack), for: .touchUpInside)
    }
}

// MARK: - Controls Actions
extension MiniPlayerView {
    @objc private func playPauseAction() {
        let pauseImage = UIImage(named: "pause")
        let playImage = UIImage(named: "play")
        if playPauseButton.currentImage == pauseImage {
            playPauseButton.setImage(playImage, for: .normal)
        } else {
            playPauseButton.setImage(pauseImage, for: .normal)
        }
        delegate?.playPauseTrack()
    }
    
    @objc private func playNextTrack() {
        delegate?.nextTrack()
    }
}

// MARK: Setup Layout
extension MiniPlayerView {
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [coverImageView, trackNameLabel, playPauseButton, nextTrackButton], axis: .horizontal, spacing: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            coverImageView.widthAnchor.constraint(equalToConstant: 48.0),
            playPauseButton.widthAnchor.constraint(equalToConstant: 44.0),
            nextTrackButton.widthAnchor.constraint(equalToConstant: 48.0)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
        ])
    }
}
