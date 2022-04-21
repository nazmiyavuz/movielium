//
//  UpcomingMovieTableViewCell.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit
import Kingfisher

class UpcomingMovieTableViewCell: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else {
                Logger.error("getting movie"); return
            }

            titleLabel.text = movie.shownTitle
            descriptionLabel.text = movie.overview
            dateLabel.text = movie.shownReleaseDate
            
            let urlString =  Endpoint.movieImage(image: movie.backdropPath ?? "").urlString
            loadMovieImage(with: urlString)
        }
    }
    
    // MARK: - Services
    
    private func loadMovieImage(with urlString: String) {
        movieImageView.kf.indicatorType = .activity
        
        guard let url = URL(string: urlString) else {
            Logger.error("getting url"); return
        }
        movieImageView.kf.setImage(with: url, placeholder: UIImage.moviePlaceholderImage)
    }
}

extension UpcomingMovieTableViewCell: NibReusable {}
