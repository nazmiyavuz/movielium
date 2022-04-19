//
//  MainNavigator.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

/// to navigate the screens in an easy way
protocol MainNavigator {
    /// First screen which is at the beginning of the app
    associatedtype StartScreen
    /// General destination which is a screen, you want to display
    associatedtype Destination
    
    /**
    Start application in the beginning from StartScreen that is an associated type
     - parameters:
       - screen: StartScreen which is associated type
       - scene: UIScene for initialising
     */
    func start(with screen: StartScreen, scene: UIScene)
    
    /**
    Navigate to another screen that is named as Destination
     - parameters:
       - destination: Destination which is an associated type, navigate to related destination
     */
    func navigate(to destination: Destination)
    
}
