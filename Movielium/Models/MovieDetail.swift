//
//  MovieDetail.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 21.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    
    let id: Int
    let title: String
    let backdropPath: String?
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    
    // Computed Properties
    var releaseDateString: String {
        return releaseDate.getTime(with: "dd.MM.yyyy")
    }
    
    var shownTitle: String {
        return title + " (" + releaseDate.getTime(with: "yyyy") + ")"
    }
    
    private init(id: Int, title: String,
                  backdropPath: String?,
                  overview: String,
                  releaseDate: String,
                  voteAverage: Double) {
        self.id = id
        self.title = title
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        
    }
    
    init(_ movie: Movie) {
        self.init(id: movie.id,
                  title: movie.title,
                  backdropPath: movie.backdropPath,
                  overview: movie.overview,
                  releaseDate: movie.releaseDate,
                  voteAverage: movie.voteAverage)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case backdropPath = "backdrop_path"
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        
    }
}
