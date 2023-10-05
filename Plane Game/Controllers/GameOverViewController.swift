//
//  GameOverViewController.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/10/23.
//

import UIKit

// MARK: - Constants

private extension CGFloat {
    static let mainDivider = 4.0
}


final class GameOverViewController: UIViewController {
    
    // MARK: - Properties
    private let score: Int64
    
    // MARK: - UI Components
    private let okButton = CustomButton(title: .ok, size: .normal)
    private let gameOverLabel = CustomLabel(title: "GAME OVER", titleSize: .bigFontSize)
    private let scoreLabel = CustomLabel(titleSize: .littleFontSize)
    
    // MARK: - init
    init(score: Int64) {
        self.score = score
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .systemRed
        view.addSubview(gameOverLabel)
        view.addSubview(scoreLabel)
        view.addSubview(okButton)
        
        setupButtons()
        setupConstraints()
    }
    
    private func setupButtons() {
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOverLabel.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: -.offset32),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            okButton.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: .offset64),
            okButton.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -.offset64),
            okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: UIScreen.main.bounds.height / .mainDivider),
            okButton.heightAnchor.constraint(equalToConstant: .mainSize)
        ])
    }
    
    private func configure() {
        scoreLabel.text = "Score: \(score)"
    }
    
    // MARK: - @objc Methods
    @objc func okTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
