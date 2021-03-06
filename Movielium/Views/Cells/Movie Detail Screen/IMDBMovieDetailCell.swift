//
//  IMDBMovieDetailCell.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 21.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

class IMDBMovieDetailCell: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var IMDBRateLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // MARK: - Properties
    
    var values: (imdb: String?, dateString: String?)? {
        didSet {
            IMDBRateLabel.text = values?.imdb
            releaseDateLabel.text = values?.dateString
        }
    }
    
}

extension IMDBMovieDetailCell: NibReusable {}
