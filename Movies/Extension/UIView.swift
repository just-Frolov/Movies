//
//  UIView.swift
//  Movies
//
//  Created by Данил Фролов on 24.01.2022.
//

import UIKit

extension UIView {
    func addBlackGradientLayerInBackground(frame: CGRect){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.opacity = 0.3
        self.layer.insertSublayer(gradient, at: 0)
    }
}


