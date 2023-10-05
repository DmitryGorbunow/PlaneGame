//
//  AchievementsTableViewCell.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/11/23.
//

import UIKit

final class AchievementsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Components
    private let usernameLabel = CustomLabel(titleSize: .minFontSize)
    private let scoreLabel = CustomLabel(titleSize: .minFontSize)
    private let dataLabel = CustomLabel(titleSize: .minFontSize)
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        scoreLabel.text = nil
        dataLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(dataLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(usernameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dataLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            dataLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            dataLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    // MARK: - Public Methods
    func configure(score: Score) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd.MM.yy"
        scoreLabel.text = String(score.score)
        usernameLabel.text = score.userName
        
        guard let date = score.date else { return }
        dataLabel.text = dateFormatter.string(from: date)
    }
    
}
