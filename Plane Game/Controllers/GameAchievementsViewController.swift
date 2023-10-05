//
//  GameAchievementsViewController.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/10/23.
//

import UIKit

// MARK: - Constants

private extension CGFloat {
    static let mainFrameSize = 100.0
    static let mainDivider = 3.0
}

final class GameAchievementsViewController: UIViewController {
    
    // MARK: - Properties
    var scores = [Score]()
    
    // MARK: - UI Components
    private let okButton = CustomButton(title: .ok, size: .normal)
    private let gameRecordsLabel = CustomLabel(title: "Game Records", titleSize: .bigFontSize)
    
    private let achievementsTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupCoreData()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(achievementsTableView)
        view.addSubview(okButton)
        view.addSubview(gameRecordsLabel)
        setupButtons()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gameRecordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset16),
            gameRecordsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset16),
            gameRecordsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .offset32),
            gameRecordsLabel.heightAnchor.constraint(equalToConstant: .bigFontSize),
            
            achievementsTableView.topAnchor.constraint(equalTo: gameRecordsLabel.bottomAnchor, constant: .offset32),
            achievementsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            achievementsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            achievementsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height / .mainDivider),
            
            okButton.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: .offset64),
            okButton.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -.offset64),
            okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: UIScreen.main.bounds.height / .mainDivider),
            okButton.heightAnchor.constraint(equalToConstant: .mainSize)
        ])
    }
    
    private func setupTableView() {
        achievementsTableView.delegate = self
        achievementsTableView.dataSource = self
        achievementsTableView.register(AchievementsTableViewCell.self, forCellReuseIdentifier: AchievementsTableViewCell.identifier)
    }
    
    private func setupCoreData() {
        let context = CoreDataStack.context
        let objects = try? context.fetch(CoreDataStack.fetchRequest)
        scores = objects ?? []
        scores.sort(by: { $0.score > $1.score })
    }
    
    private func setupButtons() {
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
    }
    
    // MARK: - @objc Methods
    @objc func okTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GameAchievementsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AchievementsTableViewCell.identifier) as? AchievementsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(score: scores[indexPath.row])
        return cell
    }
}
