//
//  UIViewController.swift
//  Movies
//
//  Created by Данил Фролов on 11.01.2022.
//

import UIKit

//MARK: - Alert -
extension UIViewController {
    typealias EmptyBlock = () -> ()
    typealias AlertButtonAction = (String, EmptyBlock)
    
    func showActionSheetWithCancel(actions: [AlertButtonAction], with alertTitle: String) {
        let actionSheet = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        
        for value in actions {
            actionSheet.addAction(UIAlertAction(title: value.0, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                value.1()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showAlert(with title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
