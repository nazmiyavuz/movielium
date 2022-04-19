//
//  StoryboardLoadable.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

/// to prevent any typo during writing a name that belongs any storyboard
/// You have to add the name when you add a new storyboard
/// - Tag: StoryboardName
public enum StoryboardName: String {
    case main = "Main"
}

/// to handle calling a ViewController which is created in related storyboard
public protocol StoryboardLoadable {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardLoadable where Self: UIViewController {
    
    public static var storyboardName: String {
        return String(describing: self)
    }

    public static var storyboardIdentifier: String {
        return String(describing: self)
    }

    /// to handle calling a UIViewController in a safer way
    /// - Parameter name: [StoryboardName](x-source-tag://StoryboardName) that the related storyboard has
    /// - Returns: a UIViewController that you want to call
    public static func instantiate(fromStoryboardNamed name: StoryboardName? = nil) -> Self {
        let storyboardName = name?.rawValue ?? self.storyboardName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return instantiate(fromStoryboard: storyboard)
    }
    
    /// to handle calling a UIViewController in a safer way
    /// - Parameter storyboard: Storyboard that related viewController is in
    /// - Returns: a UIViewController that you want to call
    public static func instantiate(fromStoryboard storyboard: UIStoryboard) -> Self {
        let identifier = self.storyboardIdentifier
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Failed to instantiate view controller with identifier=\(identifier) from storyboard \( storyboard )")
        }
        return viewController
    }
    
}

extension UIViewController: StoryboardLoadable {}
