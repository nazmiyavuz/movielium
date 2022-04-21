//
//  MovieDetailViewController.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Views
    // Custom NavBar
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    // TableView
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ImageMovieDetailCell.self)
            tableView.register(cellType: IMDBMovieDetailCell.self)
            tableView.register(cellType: OverviewMovieDetailCell.self)
        }
    }
    
    // MARK: - Properties
    
    var movie: Movie?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Services
    
    private func showMovie(from movie: Movie?) {
        guard let movie = movie else {
            Logger.error("getting movie"); return
        }
        
        self.movie = movie
        
    }
    
    // MARK: - Private Functions
    
    // MARK: - Action
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        Logger.debug("pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
}

// MARK: - DataSource

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ImageMovieDetailCell
            
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as IMDBMovieDetailCell
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath) as OverviewMovieDetailCell
            return cell
        }
    }
}
// MARK: - Delegate

extension MovieDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 210 : UITableView.automaticDimension
    }
}
