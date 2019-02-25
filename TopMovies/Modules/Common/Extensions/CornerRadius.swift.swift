//
//  CornerRadius.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//


import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
