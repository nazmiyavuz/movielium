//
//  HomeViewController.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Views
    // TableView
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: UpcomingMovieTableViewCell.self)
        }
    }
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

// MARK: - DataSource

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as UpcomingMovieTableViewCell
        return cell
    }
}

// MARK: - Delegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return <#CGFloat#>
//    }
}