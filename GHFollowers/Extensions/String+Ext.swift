//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Danilo on 17/11/22.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    ///verifica se la data è convertibile in Date e la riconverte nel formato richiesto, altrimenti restituisce "N/A"
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A"}
        return date.convertToMonthYearFormat()
    }
    
}
