//
//  CustomLabel.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 10/5/23.
//

import UIKit

final class CustomLabel: UILabel {
    
    // MARK: - init
    init(title: String = "", titleSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = title
        self.font = .systemFont(ofSize: titleSize, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
