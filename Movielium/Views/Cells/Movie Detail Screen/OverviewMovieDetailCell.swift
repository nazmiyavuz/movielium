//
//  OverviewMovieDetailCell.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 21.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

class OverviewMovieDetailCell: UITableViewCell {
    
    // MARK: - Views
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    // MARK: - Properties
    var values: (title: String?, overview: String?)? {
        didSet {
            movieTitleLabel.text = values?.title
            movieOverviewLabel.text = values?.overview
        }
    }
    
}

extension OverviewMovieDetailCell: NibReusable {}
