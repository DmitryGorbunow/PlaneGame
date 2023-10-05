//
//  UIView+Extension.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/21/23.
//

import UIKit

extension UIView {
    func setShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
    }
}
