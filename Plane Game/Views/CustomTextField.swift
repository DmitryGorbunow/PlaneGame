//
//  CustomTextField.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 10/5/23.
//

import UIKit

final class CustomTextField: UITextField {
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupTextField() {
       self.backgroundColor = .systemGray6
       self.placeholder = "User"
       self.font = .systemFont(ofSize: .averageFontSize, weight: .bold)
       self.layer.cornerRadius = .mainCornerRadius
       self.setLeftPaddingPoints(.offset16)
       self.setRightPaddingPoints(.offset16)
       self.autocorrectionType = .no
       self.autocapitalizationType = .sentences
       self.translatesAutoresizingMaskIntoConstraints = false
    }
}
