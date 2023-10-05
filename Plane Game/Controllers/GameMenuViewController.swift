//
//  GameMenuViewController.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/10/23.
//

import UIKit

final class GameMenuViewController: UIViewController {
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - UI Components
    private let startButton = CustomButton(title: .start, size: .normal)
    private let achievementsButton = CustomButton(title: .gameRecords, size: .normal)
    private let settingsButton = CustomButton(title: .settings, size: .normal)
    private let gameNameLabel = CustomLabel(title: "Plane Game", titleSize: .maxFontSize)
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(startButton)
        view.addSubview(achievementsButton)
        view.addSubview(settingsButton)
        view.addSubview(gameNameLabel)
        setupButtons()
        setupConstraints()
    }
    
    private func setupButtons() {
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        achievementsButton.addTarget(self, action: #selector(achievementsTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gameNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .offset64),
            gameNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset16),
            gameNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset16),
            gameNameLabel.heightAnchor.constraint(equalToConstant: .maxFontSize),
            
            achievementsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            achievementsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            achievementsButton.heightAnchor.constraint(equalToConstant: .mainSize),
            achievementsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset64),
            achievementsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset64),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: achievementsButton.topAnchor, constant: -.offset32),
            startButton.heightAnchor.constraint(equalToConstant: .mainSize),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset64),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset64),
            
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: achievementsButton.bottomAnchor, constant: .offset32),
            settingsButton.heightAnchor.constraint(equalToConstant: .mainSize),
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset64),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset64),
        ])
    }
    
    private func getGameSettings() -> GameSettings {
        if let gameSettings = userDefaults.readData(type: GameSettings.self, key: "gameSettings") {
            return gameSettings
        } else {
            return GameSettings()
        }
    }
    
    // MARK: - @objc Methods
    @objc func startTapped() {
        let vc = GameViewController(gameSettings: getGameSettings())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func achievementsTapped() {
        let vc = GameAchievementsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingsTapped() {
        let vc = GameSettingsViewController(gameSettings: getGameSettings())
        navigationController?.pushViewController(vc, animated: true)
    }
}
