//
//  MainTabBarController.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func minimizeTrackDetailsView()
    func maximizeTrackDetailsView(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    private var viewControllerBuilder: ViewControllerBuilder?
    private var searchViewController: SearchViewController?
    private let trackDetailView = TrackDetailsView()
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        searchViewController?.tabBarDelegate = self
        trackDetailView.tabBarDelegate = self
    }
    
    // MARK: Setup View
    
    private func setupView() {
        view.backgroundColor = .white
        setupTabBar()
        generateNavigationControllers()
        setupTrackPlayerView()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(red: 255.0, green: 0.0, blue: 96.0, alpha: 1.0)
        tabBar.layer.borderColor = UIColor.systemGray4.cgColor
        tabBar.layer.borderWidth = 1.0
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    func generateNavigationControllers() {
        guard let searchImage = UIImage(named: "search"),
              let libraryImage = UIImage(named: "library")
        else {
            fatalError("Cannot find images to setup view")
        }
        
        let searchTitle = "Search"
        let libraryTitle = "Library"
        
        let libraryViewController = LibraryViewController()
        
        viewControllerBuilder = SearchViewControllerBuilder()
        searchViewController = viewControllerBuilder?
            .produceInteractor()
            .producePresenter()
            .produceRouter()
            .build() as? SearchViewController
        guard let searchViewController = searchViewController else { return }
    
        self.viewControllers = [
            generateNavigationController(rootViewController: searchViewController, title: searchTitle, image: searchImage),
            generateNavigationController(rootViewController: libraryViewController, title: libraryTitle, image: libraryImage)
        ]
    }
    
    private func setupTrackPlayerView() {
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchViewController
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        
        
        NSLayoutConstraint.activate([
            bottomAnchorConstraint,
            maximizedTopAnchorConstraint,
            trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

// MARK: - MainTabBarController Delegate
extension MainTabBarController: MainTabBarControllerDelegate {
    func minimizeTrackDetailsView() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1) {
                self.view.layoutIfNeeded()
                self.tabBar.alpha = 1
                self.trackDetailView.showMiniPlayer()
            }
    }
    
    func maximizeTrackDetailsView(viewModel: SearchViewModel.Cell?) {
        maximizedTopAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1) {
                self.view.layoutIfNeeded()
                self.tabBar.alpha = 0
                self.trackDetailView.hideMiniPlayer()
            }
        
        guard let viewModel = viewModel else { return }
        trackDetailView.set(viewModel: viewModel)
    }
}
