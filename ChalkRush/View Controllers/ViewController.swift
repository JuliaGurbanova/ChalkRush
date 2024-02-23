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
        view.backgroundColor = .background
        setupUI()
    }

    func setupUI() {
        let logoImageView = UIImageView(image: .flag)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        let startButton = UIButton.createButton(title: "Start Game",target: self, action: #selector(startButtonTapped))
        let settingsButton = UIButton.createButton(title: "Settings",target: self, action: #selector(settingsButtonTapped))
        let leaderboardButton = UIButton.createButton(title: "Leaderboard",target: self, action: #selector(leaderboardButtonTapped))

        // StackView to organize buttons vertically
        let stackView = UIStackView(arrangedSubviews: [startButton, settingsButton, leaderboardButton])
        stackView.axis = .vertical
        stackView.spacing = Paddings.settingsPadding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: ImageFrame.size),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.settingsPadding),
            logoImageView.heightAnchor.constraint(equalToConstant: ImageFrame.size * 2),

            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Paddings.standard * 2),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func startButtonTapped() {
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }

    @objc func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    @objc func leaderboardButtonTapped() {
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
}
