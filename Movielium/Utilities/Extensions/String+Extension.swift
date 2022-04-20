//
//  String+Extension.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

extension String {
    
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
    
    func getDayMonthYearFormat() -> String {
        let date = self.getDate()
        return date.getDayMonthYearFormat()
    }
    
}
