//
//  AppNavigator.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

final class AppNavigator: MainNavigator {
    enum StartScreen {
        case movieList
        
        var storyboard: StoryboardName {
            switch self {
            case .movieList: return .main
            }
        }
    }
    
    enum Destination {
        case movieDetail
        
        var storyboard: StoryboardName {
            switch self {
            case .movieDetail: return .main
            }
        }
    }
    
    static let shared = AppNavigator()
        
    // MARK: Properties
    private var window: UIWindow?
    
    private var navigationController: UINavigationController?
    
    // MARK: Initialiser
    private init() {
        self.window?.backgroundColor = .white
    }
    
    // MARK: - Start
    func start(with screen: StartScreen, scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else {
            Logger.error("getting windowScene"); return
        }
        window = UIWindow(windowScene: windowScene)
        switch screen {
        case .movieList:
            let viewController = MovieListViewController.instantiate(fromStoryboardNamed: screen.storyboard)
            let navigationController = UINavigationController(rootViewController: viewController)
            self.navigationController = navigationController
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = self.navigationController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Navigate
    func navigate(to destination: Destination) {
        switch destination {
            
        // MARK: Authentication
            
        case .movieDetail:
            let viewController = MovieDetailViewController.instantiate(fromStoryboardNamed: destination.storyboard)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
