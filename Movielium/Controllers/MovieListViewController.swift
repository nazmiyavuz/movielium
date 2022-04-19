//
//  MovieListViewController.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//

import UIKit

class MovieListViewController: UIViewController {
    
    // MARK: - Views
    // TableView
    @IBOutlet weak var tableView: UITableView! {
        didSet {
//            tableView.register(cellType: <#cell#>.self)
        }
    }
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBlue
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Services
    
    // MARK: - Private Functions
    
    // MARK: - Action
    
    // MARK: - Helpers

    @IBAction func movieDetailButtonPressed(_ sender: UIButton) {
        Logger.debug("pressed")
        
        let appNavigator: AppNavigator = .shared
        appNavigator.navigate(to: .movieDetail)
    }

}

