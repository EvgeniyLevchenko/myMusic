//
//  TrackDetailView.swift
//  myMusic
//
//  Created by QwertY on 20.02.2023.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailsView: UIView {
    
    // MARK: - UI Elements
    private let miniPlayerView = MiniPlayerView()
    private var mainStackView = UIStackView()
    private let dragDownButton = UIButton(
        title: "",
        titleColor: .systemGray,
        image: UIImage(named: "dragDown"),
        tintColor: .systemGray,
        backgroundColor: .mainWhite()
    )
    private let coverImageView = UIImageView(
        image: UIImage(systemName: "music.note"),
        cornerRadius: 5.0,
        isShadow: true
    )
    private let currentTimeSlider = UISlider(value: 0.0)
    private let currentTimeLabel = UILabel(
        text: "00:00",
        font: .systemFont(ofSize: 15),
        textColor: .systemGray,
        textAlignment: .left
    )
    private let durationLabel = UILabel(
        text: "--:--",
        font: .systemFont(ofSize: 15),
        textColor: .systemGray,
        textAlignment: .right
    )
    private let trackTitleLabel = UILabel(
        text: "Track title",
        font: .systemFont(ofSize: 24.0, weight: .semibold),
        textAlignment: .center
    )
    private let artistNameLabel = UILabel(
        text: "Author",
        font: .systemFont(ofSize: 24.0, weight: .light),
        textColor: .systemRed,
        textAlignment: .center
    )
    private let previousTrackButton = UIButton(
        title: "",
        image: UIImage(named: "left"),
        tintColor: .darkText,
        backgroundColor: .mainWhite()
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
    private let volumeSlider = UISlider(value: 1.0)
    private let minVolumeImageView = UIImageView(image: UIImage(named: "iconMin"))
    private let maxVolumImageView = UIImageView(image: UIImage(named: "iconMax"))

    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var delegate: TracksNavigationDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    private var initialCenter = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupView()
        backgroundColor = .mainWhite()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMiniPlayer() {
        miniPlayerView.alpha = 1
    }
    
    func hideMiniPlayer() {
        miniPlayerView.alpha = 0
    }
    
    func showMainPlayer() {
        mainStackView.alpha = 1
    }
    
    func hideMainPlayer() {
        mainStackView.alpha = 0
    }
}

// MARK: - Setup View
extension TrackDetailsView {
    private func setupView() {
        addButtonsTargets()
        transformCoverImageView()
        setMiniViewPlayerDelegate()
        hideMiniPlayer()
        addGestures()
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        transformCoverImageView()
        miniPlayerView.set(viewModel: viewModel)
        miniPlayerView.setState(playerState: .playing)
        trackTitleLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        coverImageView.sd_setImage(with: url)
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func addGestures() {
        miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    private func addButtonsTargets() {
        currentTimeSlider.addTarget(self, action: #selector(handleCurrentTimeSlider), for: .touchUpInside)
        dragDownButton.addTarget(self, action: #selector(dragDownButtonTapped), for: .touchUpInside)
        previousTrackButton.addTarget(self, action: #selector(playPreviousTrack), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        nextTrackButton.addTarget(self, action: #selector(playNextTrack), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(handleVolumeSlider), for: .touchUpInside)
    }
    
    private func setMiniViewPlayerDelegate() {
        miniPlayerView.delegate = self
    }
}

// MARK: - Gestures
extension TrackDetailsView {
    @objc private func handleTapMaximized() {
        tabBarDelegate?.maximizeTrackDetailsView(viewModel: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            initialCenter = self.center
            break
        case .changed:
            handleMiniPlayerPanChanged(gesture: gesture)
        case .ended:
            handleMiniPlayerPanEnded(gesture: gesture)
            break
        case .possible:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .possible:
            break
        case .began:
            initialCenter = self.center
        case .changed:
            handleMainPlayerPanChanged(gesture: gesture)
        case .ended:
            handleMainPlayerPanEnded(gesture: gesture)
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    private func handleMiniPlayerPanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        guard translation.y < 0 else { return }
        
        let newAlpha = 1 + translation.y / frame.height
        self.miniPlayerView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.mainStackView.alpha = -translation.y / frame.height
        
        let newCenter = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
        self.center = newCenter
    }
    
    private func handleMiniPlayerPanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
                self.center = self.initialCenter
                if translation.y < -200 || velocity.y < -500 {
                    self.tabBarDelegate?.maximizeTrackDetailsView(viewModel: nil)
                    self.showMainPlayer()
                } else {
                    self.showMiniPlayer()
                }
            }
    }
    
    private func handleMainPlayerPanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        guard translation.y > 0 else { return }
        
        let newAlpha = 1 - translation.y / frame.height
        self.mainStackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.miniPlayerView.alpha = translation.y / frame.height
        
        let newCenter = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
        self.center = newCenter
    }
    
    private func handleMainPlayerPanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
                self.center = self.initialCenter
                if translation.y > 100 || velocity.y > 500 {
                    self.tabBarDelegate?.minimizeTrackDetailsView()
                    self.showMainPlayer()
                } else {
                    self.hideMiniPlayer()
                    self.showMainPlayer()
                }
            }
    }
}

// MARK: - Time Setup
extension TrackDetailsView {
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeCoverImageView()
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let currentTimeText = time.toDisplayString()
            self?.currentTimeLabel.text = currentTimeText
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
}

// MARK: - Animations
extension TrackDetailsView {
    private func transformCoverImageView() {
        let scale: CGFloat = 0.8
        coverImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    private func enlargeCoverImageView() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
                self.coverImageView.transform = .identity
        }
    }
    
    private func reduceCoverImageView() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
                self.transformCoverImageView()
        }
    }
}

// MARK: - Controls actions
extension TrackDetailsView {
    @objc private func handleCurrentTimeSlider() {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @objc private func dragDownButtonTapped() {
        miniPlayerView.setState(playerState: player.timeControlStatus)
        self.tabBarDelegate?.minimizeTrackDetailsView()
    }
    
    @objc private func playPreviousTrack() {
        guard let viewModel = delegate?.moveToPreviousTrack() else { return }
        set(viewModel: viewModel)
    }
    
    @objc private func playNextTrack() {
        guard let viewModel = delegate?.moveToNextTrack() else { return }
        set(viewModel: viewModel)
    }
    
    @objc private func playPauseAction() {
        switch player.timeControlStatus {
        case .paused:
            player.play()
            let playImage = UIImage(named: "pause")
            playPauseButton.setImage(playImage, for: .normal)
            miniPlayerView.setState(playerState: .playing)
            enlargeCoverImageView()
        case .playing:
            player.pause()
            let pauseImage = UIImage(named: "play")
            playPauseButton.setImage(pauseImage, for: .normal)
            miniPlayerView.setState(playerState: .paused)
            reduceCoverImageView()
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handleVolumeSlider() {
        player.volume = volumeSlider.value
    }
}

// MARK: - Mini Player Delegate
extension TrackDetailsView: MiniPlayerDelegate {
    func playPauseTrack() {
        playPauseAction()
    }
    
    func nextTrack() {
        playNextTrack()
    }
}

// MARK: - Setup Layout
extension TrackDetailsView {
    private func setupLayout() {
        
        miniPlayerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(miniPlayerView)
        NSLayoutConstraint.activate([
            miniPlayerView.topAnchor.constraint(equalTo: self.topAnchor),
            miniPlayerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            miniPlayerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            miniPlayerView.heightAnchor.constraint(equalToConstant: 64.0)
        ])
        
        let timeStackView = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel], axis: .horizontal, distribution: .fillEqually)
        let durationStackView = UIStackView(arrangedSubviews: [currentTimeSlider, timeStackView], axis: .vertical)
        let infoStackView = UIStackView(arrangedSubviews: [trackTitleLabel, artistNameLabel], axis: .vertical, alignment: .center)
        let controlsStackView = UIStackView(arrangedSubviews: [previousTrackButton, playPauseButton, nextTrackButton], axis: .horizontal, distribution: .fillEqually, alignment: .center)
        let volumeStackView = UIStackView(arrangedSubviews: [minVolumeImageView, volumeSlider, maxVolumImageView], axis: .horizontal, spacing: 10.0)
        
        mainStackView = UIStackView(arrangedSubviews: [
            dragDownButton,
            coverImageView,
            durationStackView,
            infoStackView,
            controlsStackView,
            volumeStackView
        ], axis: .vertical, spacing: 10)
        dragDownButton.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            dragDownButton.heightAnchor.constraint(equalToConstant: 44.0),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 1.0),
            minVolumeImageView.heightAnchor.constraint(equalToConstant: 17.0),
            minVolumeImageView.widthAnchor.constraint(equalToConstant: 17.0),
            maxVolumImageView.heightAnchor.constraint(equalToConstant: 17.0),
            maxVolumImageView.widthAnchor.constraint(equalToConstant: 17.0)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70)
        ])
    }
}
