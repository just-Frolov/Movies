//
//  UIViewController.swift
//  Movies
//
//  Created by Данил Фролов on 11.01.2022.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    func showAlert(_ title: String, with message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showSpinner(_ spinner: JGProgressHUD) {
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.view else { return }
            spinner.show(in: view)
        }
    }
    
    func hideSpinner(_ spinner: JGProgressHUD) {
        DispatchQueue.main.async {
            spinner.dismiss()
        }
    }
    
    func createDecimalNumber(from largeNumber: Int) -> String {
        guard largeNumber != 0 else {
            return K.MovieDetails.noDescription
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) ?? K.MovieDetails.noDescription
        let currencyValue = formattedNumber + K.MovieDetails.currency
        return currencyValue
    }
    
    func formatDate(from originalDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        let receivedFormat = "yyyy-MM-dd"
        dateFormatterGet.dateFormat = receivedFormat

        let dateFormatterPrint = DateFormatter()
        let printFormat = "d MMMM, yyyy"
        let formattingLanguage = "ru_RU"
        dateFormatterPrint.locale = Locale(identifier: formattingLanguage)
        dateFormatterPrint.dateFormat = printFormat

        if let date = dateFormatterGet.date(from: originalDate) {
            return dateFormatterPrint.string(from: date)
        } else {
            return originalDate
        }
    }
    
    func createItemList(by itemArray: [GenreModel]) -> String? {
        var itemList = String()
        for item in itemArray {
            itemList.addingDevidingPrefixIfNeeded()
            itemList += item.name.capitalizingFirstLetter()
        }
        return itemList
    }
}
