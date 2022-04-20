//
//  UpcomingMovieTableViewCell.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    var movie: Movie? {
        didSet {
            titleLabel.text = movie?.shownTitle
            descriptionLabel.text = movie?.overview
            dateLabel.text = movie?.releaseDateString
        }
    }
    
    // MARK: - LifeCycle
    
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Services
    
    // MARK: - Private Functions
    
    // MARK: - Action
    
}

extension UpcomingMovieTableViewCell: NibReusable {}
