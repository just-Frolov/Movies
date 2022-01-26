//
//  UIView.swift
//  Movies
//
//  Created by Данил Фролов on 24.01.2022.
//

import UIKit

extension UIView {
    func addGradientLayerInBackground(with colors: [UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = colors.map{ $0.cgColor }
        //gradient.locations = locations
        gradient.opacity = 0.3
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addShadow(with color: CGColor) {
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: 20).cgPath
    }
    
    func setCornerRadius(_ value: CGFloat) {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
}


