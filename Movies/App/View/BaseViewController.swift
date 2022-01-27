//
//  BaseViewController.swift
//  Movies
//
//  Created by Данил Фролов on 27.01.2022.
//

import JGProgressHUD

class BaseViewController: UIViewController {
    //MARK: - Constants -
    private lazy var spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Internal
    func showSpinner() {
        spinner.show(in: view)
    }
    
    func hideSpinner() {
        spinner.dismiss()
    }
}
