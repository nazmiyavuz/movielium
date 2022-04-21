//
//  CGFloat+Extension.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 21.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

extension CGFloat {
    
    /// Control equality
    /// - Parameter list: [CGFloat]
    /// - Returns: boolean value true or false
    func controlEqualityAny(_ list: [CGFloat]) -> Bool {
        for number in list where number == self {
            return true
        }
        return false
    }
    
}
