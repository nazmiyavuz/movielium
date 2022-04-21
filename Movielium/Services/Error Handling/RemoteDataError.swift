//
//  RemoteDataError.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

enum RemoteDataError: Error {
    case known(String)
    case unknown
}

extension RemoteDataError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .known(let description): return description
        case .unknown:                return "Something wrong!"
        }
    }
    
}

extension RemoteDataError: CustomAlertPresentable {
    
    var alert: (title: String?, message: String?) {
        let unknownMessage = "You should check your internet connection and try again later."
        return ("Something wrong!", unknownMessage)
    }
    
}
