//
//  ChangePlaneCollectionViewCell.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/21/23.
//

import UIKit

final class ChangePlaneCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Components
    private let planeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        planeImageView.image = nil
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(planeImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            planeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            planeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            planeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            planeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    // MARK: - Public Methods
    func configure(planeName: String) {
        planeImageView.image = UIImage(named: planeName)
    }
}
