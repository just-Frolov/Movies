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
        spinner.show(in: view)
    }
    
    func hideSpinner(_ spinner: JGProgressHUD) {
        spinner.dismiss()
    }
    
    func createDecimalNumber(from largeNumber: Int) -> String {
        guard largeNumber != 0 else {
            return "No Info"
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) ?? "?"
        let currencyValue = formattedNumber + " USD"
        return currencyValue
    }
    
    func formatDate(from originalDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "ru_RU")
        dateFormatterPrint.dateFormat = "d MMMM, yyyy"

        if let date = dateFormatterGet.date(from: originalDate) {
            return dateFormatterPrint.string(from: date)
        } else {
            return originalDate
        }
    }
}
