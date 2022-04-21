//
//  ImageMovieDetailCell.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 21.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit
import Kingfisher

class ImageMovieDetailCell: UITableViewCell {
    
    // MARK: - Views
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    // MARK: - Properties
    
    var imageURL: URL? {
        didSet {
            guard let imageURL = imageURL else {
                Logger.error("getting imageURLString"); return
            }
            movieImageView.kf.indicatorType = .activity
            movieImageView.kf.setImage(with: imageURL,
                                       placeholder: UIImage.moviePlaceholderImage)
        }
    }
    
}

extension ImageMovieDetailCell: NibReusable {}
