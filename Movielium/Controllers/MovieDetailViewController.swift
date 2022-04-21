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
    private var networkManager: NetworkManager = .shared
    
    var movieDetail: MovieDetail?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetailsFromRemote()
    }
    
    // MARK: - Services
    
    private func fetchMovieDetailsFromRemote() {
        guard let detail = movieDetail else {
            Logger.error("getting movieDetail"); return
        }
        
        networkManager.fetchResult(
            endpoint: .movieDetail(id: detail.id)) {
                [weak self] (result: Result<MovieDetail, RemoteDataError>) in
                switch result {
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    self?.showMovieDetails(from: detail)
                    
                case .success(let data):
                    self?.showMovieDetails(from: data)
                }
            }
    }
    
    private func showMovieDetails(from detail: MovieDetail?) {
        guard let detail = detail else {
            Logger.error("getting movie"); return
        }
        movieDetail = detail
        
        DispatchQueue.main.async {
            self.movieTitleLabel.text = detail.shownTitle
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Action
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
            let urlString = Endpoint.movieImage(image: movieDetail?.backdropPath ?? "").urlString
            let url = URL(string: urlString)
            cell.imageURL = url
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as IMDBMovieDetailCell
            cell.values = ("\(movieDetail?.voteAverage ?? 0)", movieDetail?.shownReleaseDate)
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath) as OverviewMovieDetailCell
            cell.values = (movieDetail?.shownTitle, movieDetail?.overview)
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
