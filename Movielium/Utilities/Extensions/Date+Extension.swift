//
//  Date+Extension.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Date {
    
    func getDayMonthYearFormat() -> String {
        guard let value = self else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: value)
    }
    
}
