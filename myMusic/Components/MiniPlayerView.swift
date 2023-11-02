//
//  MiniPlayerView.swift
//  myMusic
//
//  Created by QwertY on 05.03.2023.
//

import UIKit
import AVKit

class MiniPlayerView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MiniPlayerDelegate?
    
    // MARK: - Private properties
    
    private var playerState = AVPlayer.TimeControlStatus.paused
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func set(viewModel: SearchViewModel.Cell) {
        trackNameLabel.text = viewModel.trackName
        let stringUrl = viewModel.iconUrlString
        guard let url = URL(string: stringUrl ?? "") else { return }
        coverImageView.sd_setImage(with: url)
    }
    
    func setState(playerState: AVPlayer.TimeControlStatus) {
        switch playerState {
        case .paused:
            self.playerState = .paused
            let playImage = UIImage(named: "play")
            playPauseButton.setImage(playImage, for: .normal)
        case .playing:
            self.playerState = .playing
            let pauseImage = UIImage(named: "pause")
            playPauseButton.setImage(pauseImage, for: .normal)
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        setupBorderView()
        addButtonsTargets()
    }
    
    private func setupBorderView() {
        borderView.backgroundColor = .systemGray5
    }
    
    private func addButtonsTargets() {
        playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        nextTrackButton.addTarget(self, action: #selector(playNextTrack), for: .touchUpInside)
    }
    
    @objc private func playPauseAction() {
        switch playerState {
        case .paused:
            playerState = .playing
            setState(playerState: playerState)
        case .playing:
            playerState = .paused
            setState(playerState: playerState)
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
        delegate?.playPauseTrack()
    }
    
    @objc private func playNextTrack() {
        playerState = .playing
        setState(playerState: playerState)
        delegate?.nextTrack()
    }
    
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
