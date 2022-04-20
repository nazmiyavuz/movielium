//
//  Endpoint+Enum.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

protocol BaseURL {
    var baseURLString: String { get }
}

enum Endpoint {
    
    case nowPlayingMovies
    case upcomingMovies
    case movieDetail(Int)
    case movieImage(String)
    
    private var baseURLString: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var urlString: String {
        switch self {
        case .nowPlayingMovies:      return baseURLString + "movie/now_playing"
        case .upcomingMovies:        return baseURLString + "movie/upcoming"
        case .movieDetail(let id):   return baseURLString + "movie/\(id)"
        case .movieImage(let image): return "https://image.tmdb.org/t/p/w500/\(image)"
        }
    }
}
