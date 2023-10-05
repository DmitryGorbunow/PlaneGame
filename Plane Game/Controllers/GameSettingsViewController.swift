//
//  GameSettingsViewController.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/10/23.
//

import UIKit

// MARK: - Constants
private extension CGFloat {
    static let imageSize = 40.0
    static let collectionViewSpacing = 10.0
    static let collectionViewItemSize = 200.0
}

private enum Constants {
    static let gameSpeedMax: Double = 2
    static let gameSpeedMin: Double = 1
    static let gameSpeedStep: Double = 1
}

final class GameSettingsViewController: UIViewController {
    
    // MARK: - Properties
    private var gameSettings: GameSettings
    private let planeNames = ["plane0", "plane1", "plane2", "plane3"]
    private let userDefaults = UserDefaults.standard
    
    // MARK: - init
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let okButton = CustomButton(title: .ok, size: .normal)
    
    private let userNameTextField = CustomTextField()
    
    private let planePictureLabel = CustomLabel(title: "Plane Icon", titleSize: .averageFontSize)
    private let userNameLabel = CustomLabel(title: "Username", titleSize: .averageFontSize)
    private let speedLabel = CustomLabel(title: "Game Speed", titleSize: .averageFontSize)
    private let speedValueLabel = CustomLabel(title: "", titleSize: .averageFontSize)
    
    private let leftImageView = CustomImageView(imageName: .swipeLeft)
    private let rightImageView = CustomImageView(imageName: .swipeRight)
    
    private let plusButton = CustomButton(title: .none, size: .little, imageName: "plus.circle")
    private let minusButton = CustomButton(title: .none, size: .little, imageName: "minus.circle")
    
    private let stackView = CustomStackView(axis: .vertical, distribution: .equalSpacing, alignment: .fill)
    private let gameSpeedStackView = CustomStackView(axis: .horizontal, distribution: .equalSpacing, alignment: .center)
    private let changePlaneStackView = CustomStackView(axis: .horizontal, distribution: .equalSpacing, alignment: .center)
    
    private let changePlaneCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .collectionViewSpacing
        layout.itemSize = CGSize(width: .collectionViewItemSize, height: .collectionViewItemSize)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        speedValueLabel.text = String(Int(self.gameSettings.gameSpeed))
        userNameTextField.placeholder = self.gameSettings.username
        setupViews()
        userNameTextField.delegate = self
        activateKeyboardRemoval()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = IndexPath.init(item: gameSettings.planeIcon, section: 0)
        changePlaneCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(changePlaneStackView)
        view.addSubview(gameSpeedStackView)
        changePlaneStackView.addArrangedSubview(leftImageView)
        changePlaneStackView.addArrangedSubview(changePlaneCollectionView)
        changePlaneStackView.addArrangedSubview(rightImageView)
        gameSpeedStackView.addArrangedSubview(minusButton)
        gameSpeedStackView.addArrangedSubview(speedValueLabel)
        gameSpeedStackView.addArrangedSubview(plusButton)
        stackView.addArrangedSubview(planePictureLabel)
        stackView.addArrangedSubview(changePlaneStackView)
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userNameTextField)
        stackView.addArrangedSubview(speedLabel)
        stackView.addArrangedSubview(gameSpeedStackView)
        stackView.addArrangedSubview(okButton)
        setupButtons()
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.offset32),

            changePlaneCollectionView.heightAnchor.constraint(equalToConstant: .collectionViewItemSize),
            changePlaneCollectionView.widthAnchor.constraint(equalToConstant: .collectionViewItemSize + .collectionViewSpacing),
            leftImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            leftImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            rightImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            rightImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            userNameTextField.heightAnchor.constraint(equalToConstant: .mainSize),
            okButton.heightAnchor.constraint(equalToConstant: .mainSize)
        ])
    }
    
    private func activateKeyboardRemoval() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func setupCollectionView() {
        changePlaneCollectionView.dataSource = self
        changePlaneCollectionView.delegate = self
        changePlaneCollectionView.register(ChangePlaneCollectionViewCell.self, forCellWithReuseIdentifier: ChangePlaneCollectionViewCell.identifier)
    }
    
    private func setupButtons() {
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - @objc Methods
    @objc func okTapped() {
        navigationController?.popToRootViewController(animated: true)
        userDefaults.saveData(someData: gameSettings, key: "gameSettings")
    }
    
    @objc func minusButtonTapped() {
        if gameSettings.gameSpeed > Constants.gameSpeedMin {
            gameSettings.gameSpeed -= Constants.gameSpeedStep
            speedValueLabel.text = String(Int(gameSettings.gameSpeed))
        }
    }
    
    @objc func plusButtonTapped() {
        if gameSettings.gameSpeed < Constants.gameSpeedMax {
            gameSettings.gameSpeed += Constants.gameSpeedStep
            speedValueLabel.text = String(Int(gameSettings.gameSpeed))
        }
    }
}

// MARK: - @objc UICollectionViewDataSource, UICollectionViewDelegate
extension GameSettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        planeNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = changePlaneCollectionView.dequeueReusableCell(withReuseIdentifier: ChangePlaneCollectionViewCell.identifier, for: indexPath) as? ChangePlaneCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(planeName: planeNames[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in changePlaneCollectionView.visibleCells {
            if let row = changePlaneCollectionView.indexPath(for: cell)?.item {
                gameSettings.planeIcon = row
            }
        }
    }
}

// MARK: - @objc UITextFieldDelegate
extension GameSettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        gameSettings.username = text
    }
}
