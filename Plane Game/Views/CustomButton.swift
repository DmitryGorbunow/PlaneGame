//
//  CustomButton.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/10/23.
//
import UIKit

// MARK: - Constants
private extension CGFloat {
    static let buttonSize = 30.0
}

final class CustomButton: UIButton {
    
    enum ButtonTitle {
        case start
        case gameRecords
        case settings
        case ok
        case none
    }
    
    enum ButtonSize {
        case normal
        case little
    }
    
    // MARK: - init
    init(title: ButtonTitle, size: ButtonSize, imageName: String = "" ) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        if size == .normal {
            self.layer.cornerRadius = .mainCornerRadius
            self.setShadow()
            
            self.backgroundColor = .systemIndigo
            self.titleLabel?.font = .systemFont(ofSize: .averageFontSize, weight: .bold)
            switch title {
            case .start:
                self.setTitle("Start", for: .normal)
                
            case .gameRecords:
                self.setTitle("Game Records", for: .normal)
                
            case .settings:
                self.setTitle("Settings", for: .normal)
            
            case .ok:
                self.setTitle("OK", for: .normal)
            case .none:
                self.setTitle("", for: .normal)
            }
        } else {
            let config = UIImage.SymbolConfiguration(
                pointSize: .buttonSize, weight: .medium, scale: .default)
            self.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
            
            self.tintColor = .systemIndigo
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
