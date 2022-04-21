//
//  Endpoint+Enum.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

/// - Tag: Endpoint
enum Endpoint {
    
    case nowPlayingMovies(page: Int)
    case upcomingMovies(page: Int)
    case movieDetail(id: Int)
    case movieImage(image: String)
    
    var urlString: String {

        let baseURL = "https://api.themoviedb.org/3/"
        let params = "?api_key=\(Secrets.APIKey)&language=en-US"

        switch self {
        case .nowPlayingMovies(let page):
            return baseURL + "movie/now_playing" + params + "&page=\(page)"

        case .upcomingMovies(let page):
            return baseURL + "movie/upcoming" + params + "&page=\(page)"

        case .movieDetail(let id):
            return baseURL + "movie/\(id)" + params

        case .movieImage(let image):
            return "https://image.tmdb.org/t/p/w500/\(image)"
        }
    }
}

