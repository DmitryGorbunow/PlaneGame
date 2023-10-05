//
//  CustomImageView.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 10/5/23.
//

import UIKit

final class CustomImageView: UIImageView {
    
    enum ImageName: String {
        case swipeLeft
        case swipeRight
    }
    
    // MARK: - init
    init(imageName: ImageName) {
        super.init(frame: .zero)
        self.image = UIImage(named: imageName.rawValue)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
