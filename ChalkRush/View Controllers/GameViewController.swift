//
//  GameViewController.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, AVAudioPlayerDelegate {

    let player = DataManager.load()

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    private var countdownLabel = UILabel.createLabel(text: "")
    private var scoreLabel = UILabel.createLabel(text: "Score: 0")
    private var isCountdownFinished = false
    private var isCollisionDetected = false

    private var isSoundEnabled = true
    private var audioPlayer: AVAudioPlayer?
    private var currentSound: String?

    private var activeObstacleTimers: [Timer] = []

    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.blue.cgColor
        return imageView
    }()

    private let roadMarkingsView1 = UIImageView(image: UIImage(resource: .roadMarkings))
    private let roadMarkingsView2 = UIImageView(image: UIImage(resource: .roadMarkings))

    private var roadMarkingsAnimationTimer: Timer?
    private var obstacleGeneratorTimer: Timer?
    private var obstacleGenerationInterval: TimeInterval {
        let difficultyLevel = DifficultyLevel(rawValue: player.gameSettings.difficultyLevelIndex) ?? .medium

        switch difficultyLevel {
        case .easy:
            return ObstacleGenerationIntervals.easy
        case .medium:
            return ObstacleGenerationIntervals.medium
        case .hard:
            return ObstacleGenerationIntervals.hard
        }
    }

    private var obstacleSpeed: TimeInterval {
        let difficultyLevel = DifficultyLevel(rawValue: player.gameSettings.difficultyLevelIndex) ?? .medium

        switch difficultyLevel {
        case .easy:
            return 0.03
        case .medium:
            return 0.02
        case .hard:
            return 0.01
        }
    }

    private var roadSpeed: TimeInterval {
        obstacleGenerationInterval / 2
    }

    private var isGameRunning = false

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        let soundButton = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(toggleSound))
        navigationItem.rightBarButtonItem = soundButton
        setupUI()
        startCountdownAnimation()

    }

    // MARK: - UI Setup
    private func startCountdownAnimation() {
        var countdown = CountdownSetup.startingNumber
        countdownLabel.text = "\(countdown)"
        countdownLabel.alpha = 1.0
        countdownLabel.transform = CGAffineTransform(scaleX: CountdownSetup.labelScale, y: CountdownSetup.labelScale)

        if isSoundEnabled {
            setupAudioPlayer(track: "countdown")
            playSound()
        }
        
        UIView.animate(withDuration: CountdownSetup.duration, animations: {
            self.countdownLabel.transform = .identity
        }) { _ in
            Timer.scheduledTimer(withTimeInterval: CountdownSetup.duration, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }

                countdown -= 1
                if countdown > 0 {
                    self.countdownLabel.text = "\(countdown)"
                } else {
                    self.countdownLabel.text = "Go"
                    UIView.animate(withDuration: CountdownSetup.duration / 2, animations: {
                        self.countdownLabel.alpha = 0.0
                    }) { _ in
                        timer.invalidate()
                        self.countdownLabel.removeFromSuperview()
                        self.isCountdownFinished = true
                        self.startGame()
                    }
                }
            }
        }
    }


    private func setupUI() {
        countdownLabel.font = UIFont(name: Fonts.chalkduster.rawValue, size: FontSizes.countdown.rawValue)
        scoreLabel.font = UIFont(name: Fonts.chalkduster.rawValue, size: FontSizes.scoreLabel.rawValue)
        carImageView.image = UIImage(named: "car\(player.gameSettings.selectedCarIndex + 1)")

        view.addSubviews(countdownLabel, scoreLabel, carImageView)

        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            carImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carImageView.widthAnchor.constraint(equalToConstant: CarSize.carWidth),
            carImageView.heightAnchor.constraint(equalToConstant: CarSize.carHeight),
            carImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        carImageView.addGestureRecognizer(panGesture)
    }

    // MARK: - Game Loop
    private func startGame() {
        isGameRunning = true
        if isSoundEnabled {
            setupAudioPlayer(track: "driving")
            playSound()
        }
        startObstacleGenerator()
        animateRoadMarkings()
    }

    private func animateRoadMarkings() {
        roadMarkingsView1.frame = CGRect(x: 0, y: -view.bounds.height, width: view.bounds.width, height: view.bounds.height)
        roadMarkingsView1.layer.zPosition = -1

        roadMarkingsView2.frame = CGRect(x: 0, y: 5, width: view.bounds.width, height: view.bounds.height)
        roadMarkingsView2.layer.zPosition = -1

        view.addSubviews(roadMarkingsView1, roadMarkingsView2)

        UIView.animate(withDuration: roadSpeed, delay: 0, options: [.curveLinear, .repeat], animations: { [self] in
            self.roadMarkingsView1.frame.origin.y += self.view.bounds.height
            self.roadMarkingsView2.frame.origin.y += self.view.bounds.height
        }, completion: nil)
    }

    private func endGame() {
        stopSound()
        if score > 0 {
            saveScore()
        }
        stopRoadMarkingsAnimation()
        stopActiveObstacleTimers()
        isGameRunning = false

        showGameOverAlert()
    }

    private func stopRoadMarkingsAnimation() {
        roadMarkingsView1.layer.removeAllAnimations()
        roadMarkingsView2.layer.removeAllAnimations()
    }

    private func stopActiveObstacleTimers() {
        for timer in activeObstacleTimers {
            timer.invalidate()
        }
        activeObstacleTimers.removeAll()
    }

    private func startObstacleGenerator() {
        obstacleGeneratorTimer = Timer.scheduledTimer(timeInterval: obstacleGenerationInterval, target: self, selector: #selector(generateObstacle), userInfo: nil, repeats: true)
        activeObstacleTimers.append(obstacleGeneratorTimer!)
    }

    // MARK: - Game Actions

    @objc private func generateObstacle() {
        guard isCountdownFinished else {
            return
        }

        let randomObstacle = obstacleTypes.randomElement() ?? "npcCar1"

        let obstacleImageView = UIImageView(image: UIImage(named: randomObstacle))

        if randomObstacle == Obstacles.cone.rawValue {
            obstacleImageView.frame.size = CGSize(width: ObstacleSizes.coneWidth.rawValue, height: ObstacleSizes.coneHeight.rawValue)
        } else if randomObstacle == Obstacles.tyre.rawValue {
            obstacleImageView.frame.size = CGSize(width: ObstacleSizes.tyre.rawValue, height: ObstacleSizes.tyre.rawValue)
        } else {
            obstacleImageView.frame.size = CGSize(width: ObstacleSizes.npcCarWidth.rawValue, height: ObstacleSizes.npcCarHeight.rawValue)
        }

        obstacleImageView.contentMode = .scaleAspectFill
        obstacleImageView.center.x = CGFloat.random(in: obstacleImageView.frame.width / 2...(view.bounds.width - obstacleImageView.frame.width / 2))
        obstacleImageView.frame.origin.y = -obstacleImageView.frame.height

        obstacleImageView.image?.accessibilityIdentifier = randomObstacle

        view.addSubview(obstacleImageView)

        // update the obstacle position
        let obstacleTimer = Timer.scheduledTimer(withTimeInterval: obstacleSpeed, repeats: true) { [weak self, weak obstacleImageView] timer in

            guard let self = self, let obstacleImageView = obstacleImageView else {
                timer.invalidate()
                return
            }

            obstacleImageView.frame.origin.y += 10

            if obstacleImageView.frame.origin.y + obstacleImageView.frame.size.height >= self.carImageView.frame.origin.y {
                self.checkCollision()
                if self.isCollisionDetected {
                    timer.invalidate()
                    if isSoundEnabled {
                        DispatchQueue.main.async {
                            self.setupAudioPlayer(track: "crash")
                            self.playSound()
                        }
                    }
                    self.endGame()
                }
            }

            // Remove the obstacle when it's below the bottom of the screen
            if obstacleImageView.frame.origin.y >= self.view.bounds.height {
                obstacleImageView.removeFromSuperview()
                timer.invalidate()
                self.score += 1
            }
        }

        activeObstacleTimers.append(obstacleTimer)
    }


    private func checkCollision() {
        let playerFrame = carImageView.frame

        // Iterate through all obstacle views on the screen
        for obstacleView in view.subviews where obstacleView is UIImageView {
            if let obstacleImageView = obstacleView as? UIImageView,
               let obstacleImageName = obstacleImageView.image?.accessibilityIdentifier,
               obstacleTypes.contains(obstacleImageName) {
                let obstacleFrame = obstacleImageView.frame

                // Check for intersection between player's car and the obstacle when it reaches the bottom
                if obstacleFrame.origin.y + obstacleFrame.size.height >= playerFrame.origin.y {
                    if playerFrame.intersects(obstacleFrame) {
                        isCollisionDetected = true
                    }
                }
            }
        }
    }

    private func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Your Score: \(score)", preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset Game", style: .default) { [weak self] _ in
            self?.resetGame()
        }

        let okAction = UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }

        alert.addAction(resetAction)
        alert.addAction(okAction)

        present(alert, animated: true)
    }

    private func resetGame() {
        score = 0
        isCountdownFinished = false
        isCollisionDetected = false

        for obstacleView in view.subviews where obstacleView is UIImageView && obstacleView != carImageView {
            obstacleView.removeFromSuperview()
        }
        stopActiveObstacleTimers()

        // Reset UI
        setupUI()
        scoreLabel.text = "Score: 0"

        // Restart countdown
        startCountdownAnimation()
    }

    private func saveScore() {
        // Save the score using your data manager or score manager
        let gameScore = Score(player: player, score: score, date: Date())
        ScoreDataManager.saveScore(gameScore)
    }

    // MARK: - Gesture Recognizer
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let carImageView = sender.view else {
            return
        }

        if sender.state == .changed || sender.state == .ended {
            let translation = sender.translation(in: view)

            let newX = carImageView.center.x + translation.x
            let halfCarWidth = carImageView.frame.width / 2

            let minX = halfCarWidth
            let maxX = view.bounds.width - halfCarWidth

            carImageView.center.x = min(maxX, max(minX, newX))

            sender.setTranslation(.zero, in: view)
        }
    }

    // MARK: - Audio effects
    private func setupAudioPlayer(track: String) {
        if let soundURL = Bundle.main.url(forResource: track, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                currentSound = track
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
        }
    }

    @objc private func toggleSound() {
        isSoundEnabled.toggle()

        if isSoundEnabled {
            playSound()
        } else {
            stopSound()
        }

        let soundButtonImage = isSoundEnabled ? UIImage(systemName: "speaker") : UIImage(systemName: "speaker.slash")
        navigationItem.rightBarButtonItem?.image = soundButtonImage
    }

    private func playSound(completion: (() -> Void)? = nil) {
        audioPlayer?.play()
    }

    private func stopSound() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let currentSound = currentSound else {
            return
        }

        if currentSound == "crash" {
            endGame()
        } else if currentSound == "driving" {
            audioPlayer?.currentTime = 0
            audioPlayer?.play()
        }

        self.currentSound = nil
    }

}
