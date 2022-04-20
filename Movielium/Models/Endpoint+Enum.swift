//
//  Endpoint+Enum.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

protocol APIParameterService {
    var parameters: APIParameters { get }
}

/// - Tag: Endpoint
enum Endpoint {
    
    case nowPlayingMovies(page: Int)
    case upcomingMovies(page: Int)
    case movieDetail(id: Int)
    case movieImage(image: String)
    
    var urlString: String {
        // https://api.themoviedb.org/3/movie/now_playing?api_key=bf970ea3db4276b576be764116894ed1&language=en-US&page=1
        
        let baseURL = "https://api.themoviedb.org/3/"
        let params = "?api_key=bf970ea3db4276b576be764116894ed1&language=en-US"
        
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

extension Endpoint: APIParameterService {
    
    var parameters: APIParameters {
        
        var params: APIParameters = [
            "api_key": "bf970ea3db4276b576be764116894ed1",
            "language": "en-US"
        ]
        
        switch self {
        case .nowPlayingMovies(let page): params["page"] = "\(page)"
        case .upcomingMovies(let page):   params["page"] = "\(page)"
        case .movieDetail, .movieImage:   break
        }
        
        return params
    }
    
    
}
