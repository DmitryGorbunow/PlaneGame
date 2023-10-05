//
//  GameViewController.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/6/23.
//

import UIKit

// MARK: - Constants
private extension CGFloat {
    static let mainFrameSize = 100.0
    static let bigFrameSize = 300.0
    static let additionalFrameSize = 70.0
    static let labelHeight = 30.0
    static let offset200 = 200.0
    static let mainDivider = 2.0
    static let additionalDivider = 3.0
    static let bulletSize = 20.0
    static let randomMinY = -1000.0
    static let randomMaxY = -100.0
    static let randomAverageY = -500.0
}

private enum Constants {
    static let numberOfUFOs: Int = 3
    static let numberOfUFOsImage: Int = 6
    static let numberOfClouds: Int = 2
    static let timeInterval: Double = 60
    static let bulletDelay: Double = 2
    static let ufoStep: Double = 5
    static let cloudStep: Double = 2
    static let bulletStep: Double = 5
    static let backgroundAnimateDuration: Double = 5.0
}

final class GameViewController: UIViewController {
    
    // MARK: - Properties
    private var timer: Timer?
    private var bulletTimer: Timer?
    private var ufos: [UIImageView] = []
    private var clouds: [UIImageView] = []
    private var score: Int64 = 0
    private var gameSettings: GameSettings
    
    // MARK: - UI Components
    private let planeImageView = UIImageView()
    
    private let scoreLabel = CustomLabel(titleSize: .littleFontSize)
    
    private let bulletImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bomb")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - init
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        moveBackground()
        createClouds()
        createUFOs()
        startTimer()
        setupViews()
    }
    
    //MARK: - Private Methods
    private func setupViews() {
        view.addSubview(bulletImageView)
        view.addSubview(planeImageView)
        view.addSubview(scoreLabel)
        setupPlaneView()
        setupBulletImageView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset16),
            scoreLabel.heightAnchor.constraint(equalToConstant: .labelHeight),
        ])
    }
    
    private func setupPlaneView() {
        planeImageView.image = UIImage(named: "plane\(gameSettings.planeIcon)")
        planeImageView.frame = CGRect(x: (view.frame.width / .mainDivider) - (.mainFrameSize / .mainDivider), y: view.frame.height - (.mainFrameSize + .offset16 * .mainDivider), width: .mainFrameSize, height: .mainFrameSize)
        planeImageView.isUserInteractionEnabled = true
        planeImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(planeWasMoved)))
    }
    
    private func setupBulletImageView() {
        bulletImageView.frame = CGRect(x: (view.frame.width / .mainDivider) - (.bulletSize / .mainDivider), y: view.frame.height - .mainFrameSize, width: .bulletSize, height: .bulletSize)
    }
        
    private func createUFOs() {
        for i in 0..<Constants.numberOfUFOs {
            let ufo = UIImageView()
            let randomY = CGFloat.random(in: .randomMinY...(.randomMaxY))
            ufo.frame = CGRect(x: CGFloat(i) * (UIScreen.main.bounds.width) / .additionalDivider + .offset8, y: randomY, width: .mainFrameSize, height: .mainFrameSize)
            ufo.image = UIImage(named: "ufo\(Int.random(in: 0..<Constants.numberOfUFOs))")
            view.addSubview(ufo)
            ufos.append(ufo)
        }
    }
    
    private func createClouds() {
        for i in 0..<Constants.numberOfClouds {
            let cloud = UIImageView()
            let randomY = CGFloat.random(in: .randomAverageY...(.randomMaxY))
            cloud.frame = CGRect(x: CGFloat(i) * (UIScreen.main.bounds.width) / .additionalDivider - .offset16, y: randomY, width: .bigFrameSize, height: .bigFrameSize)
            cloud.image = UIImage(named: "cl\(Int.random(in: 0..<Constants.numberOfClouds))")
            view.addSubview(cloud)
            clouds.append(cloud)
        }
    }
    
    private func moveUFOs() {
        ufos.forEach { ufo in
            ufo.frame.origin.y += Constants.ufoStep
            if ufo.frame.origin.y > UIScreen.main.bounds.height {
                ufo.frame.origin.y = CGFloat.random(in: .randomMinY...(.randomMaxY))
                ufo.image = UIImage(named: "ufo\(Int.random(in: 0..<Constants.numberOfUFOsImage))")
                ufo.isHidden = false
            }
        }
    }
    
    private func moveClouds() {
        clouds.forEach { cloud in
            cloud.frame.origin.y += Constants.cloudStep
            if cloud.frame.origin.y > UIScreen.main.bounds.height {
                cloud.frame.origin.y = CGFloat.random(in: .randomAverageY...(.randomMaxY))
                cloud.image = UIImage(named: "cl\(Int.random(in: 0..<Constants.numberOfClouds))")
            }
        }
    }
    
    private func moveBullets() {
        bulletImageView.frame.origin.y -= Constants.bulletStep
        if bulletImageView.frame.origin.y < 0 {
            bulletTimer = Timer.scheduledTimer(withTimeInterval: Constants.bulletDelay, repeats: false, block: { [weak self] _ in
                self?.bulletImageView.frame.origin.y = (self?.view.frame.height)! - .additionalFrameSize
            })
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1/(Constants.timeInterval * gameSettings.gameSpeed), repeats: true, block: { [weak self] _ in
            self?.updateGameElements()
            self?.view.layoutIfNeeded()
        })
    }
    
    private func updateGameElements() {
        score += 1
        scoreLabel.text = String(score)
        moveClouds()
        moveUFOs()
        moveBullets()
        hitsDetection()
        collisionDetection()
    }
    
    private func hitsDetection() {
        for i in ufos {
            if i.frame.intersects(bulletImageView.frame) {
                i.isHidden = true
            }
        }
    }
    
    private func collisionDetection() {
        for i in ufos where i.isHidden == false {
            if i.frame.intersects(planeImageView.frame) {
                let vc = GameOverViewController(score: score)
                navigationController?.pushViewController(vc, animated: true)
                timer?.invalidate()
                saveScore()
            }
        }
    }
    
    private func moveBackground() {
        let backgroundImage = UIImage(named:"background")!
        let backgroundImageView1 = UIImageView(image: backgroundImage)
        backgroundImageView1.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        backgroundImageView1.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView1)
        let backgroundImageView2 = UIImageView(image: backgroundImage)
        backgroundImageView2.frame = CGRect(x: self.view.frame.origin.x, y: -self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.height)
        backgroundImageView2.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView2)
        UIView.animate(withDuration: Constants.backgroundAnimateDuration, delay: 0.0, options: [.repeat, .curveLinear], animations: {
            backgroundImageView1.frame = backgroundImageView1.frame.offsetBy(dx: 0.0 , dy: 1 * backgroundImageView1.frame.size.height)
            backgroundImageView2.frame = backgroundImageView2.frame.offsetBy(dx: 0.0, dy: 1 * backgroundImageView2.frame.size.height)
        }, completion: nil)
    }
    
    private func saveScore() {
        let newScore = Score(context: CoreDataStack.context)
        newScore.score = self.score
        newScore.date = Date()
        newScore.userName = gameSettings.username
        CoreDataStack.saveContext()
    }
    
    //MARK: - @objc Methods
    @objc private func planeWasMoved(_ gesture: UIPanGestureRecognizer) {
        if let planeView = gesture.view {
            let point = gesture.translation(in: view)
            planeView.center = CGPoint(x: planeView.center.x + point.x, y: planeView.center.y)
            bulletImageView.center = CGPoint(x: bulletImageView.center.x + point.x, y: bulletImageView.center.y)
            gesture.setTranslation(CGPoint.zero, in: view)
        }
    }
}


