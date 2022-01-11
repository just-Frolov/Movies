//
//  Alert.swift
//  Movies
//
//  Created by Данил Фролов on 11.01.2022.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String, with message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
