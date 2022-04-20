//
//  NertworkError.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case fetchFailed(Error)
    case response(String)
    case unknown
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let error): return error.localizedDescription
        case .response(let message):  return message
        case .unknown:                return "Something wrong!"
        }
    }
    
}
