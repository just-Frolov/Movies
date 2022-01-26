//
//  Int.swift
//  Movies
//
//  Created by Данил Фролов on 26.01.2022.
//

import Foundation

extension Int {
    func createDecimalNumber() -> String {
        guard self != 0 else {
            return Constants.MovieDetails.noDescription
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:self)) ?? Constants.MovieDetails.noDescription
        let currencyValue = formattedNumber + Constants.MovieDetails.currency
        return currencyValue
    }
}
