//
//  UIViewController.swift
//  Movies
//
//  Created by Данил Фролов on 11.01.2022.
//

import UIKit
import JGProgressHUD

//MARK: - Alert -
extension UIViewController {
    typealias AlertAction = () -> ()
    typealias AlertButtonAction = (String, AlertAction)
    
    func showActionSheetWithCancel(titleAndAction: [AlertButtonAction], with alertTitle: String) {
        let actionSheet = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        
        for value in titleAndAction {
            actionSheet.addAction(UIAlertAction(title: value.0, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                value.1()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String, with message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Spinner -
extension UIViewController {
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
}

//MARK: - Value conversion -
extension UIViewController {
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
