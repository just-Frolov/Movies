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
    
    func setupBackButton() {
        let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = customBackButton
    }
}
