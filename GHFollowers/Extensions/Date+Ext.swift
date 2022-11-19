//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Danilo on 17/11/22.
//

import Foundation

extension Date {
    
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
        
    }
    
}
