//
//  ViewController.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .background

        setupUI()
    }

    func setupUI() {
        let logoImageView = UIImageView()
        logoImageView.image = .flag
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        // Create three buttons
        let startButton = UIButton.createButton(title: "Start Game",target: self, action: #selector(startButtonTapped))
        let settingsButton = UIButton.createButton(title: "Settings",target: self, action: #selector(settingsButtonTapped))
        let leaderboardButton = UIButton.createButton(title: "Leaderboard",target: self, action: #selector(leaderboardButtonTapped))

        // StackView to organize buttons vertically
        let stackView = UIStackView(arrangedSubviews: [startButton, settingsButton, leaderboardButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Constraints for StackView
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),

            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 44),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func startButtonTapped() {
        // Navigate to the game screen
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }

    @objc func settingsButtonTapped() {
        // Navigate to the settings screen
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    @objc func leaderboardButtonTapped() {
        // Navigate to the leaderboard screen
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
}


