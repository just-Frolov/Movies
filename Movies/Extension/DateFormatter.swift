//
//  Date.swift
//  Movies
//
//  Created by Данил Фролов on 26.01.2022.
//

import Foundation

extension DateFormatter {
    static let dateFormattingForGetting: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let dateFormattingForPrint: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static func string(iso string: String) -> String {
        let date = DateFormatter.dateFormattingForGetting.date(from: string)!
        return  DateFormatter.dateFormattingForPrint.string(from: date)
    }
}
