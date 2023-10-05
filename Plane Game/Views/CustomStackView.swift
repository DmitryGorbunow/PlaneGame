//
//  CustomStackView.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 10/5/23.
//

import UIKit

class CustomStackView: UIStackView {
    
    // MARK: - init
    init(axis: NSLayoutConstraint.Axis, distribution:  UIStackView.Distribution, alignment: UIStackView.Alignment) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
