//
//  CustomAlertPresentable.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit
/// Show alert to the users with alert controller
protocol CustomAlertPresentable: Error {
    var alert: (title: String?, message: String?) { get }
}

extension UIViewController {
    /// Create alert according to error that is throwing
    /// - Parameter error: which is come from AlertPresentable.
    func presentCustomAlertPresentableWith(_ error: Error) {
        var alert: (title: String?, message: String?) {
            switch error as? CustomAlertPresentable {
            case let error?: return (error.alert.title, error.alert.message)
            case nil:        return ("Something went wrong!",
                                     "You should control your internet connection.")
            }
        }
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
