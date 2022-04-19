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
    
    // MARK: - Properties
    
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
