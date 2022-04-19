//
//  MovieListViewController.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//

import UIKit

class MovieListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBlue
    }

    @IBAction func movieDetailButtonPressed(_ sender: UIButton) {
        Logger.debug("pressed")
        
        let appNavigator: AppNavigator = .shared
        appNavigator.navigate(to: .movieDetail)
    }

}
