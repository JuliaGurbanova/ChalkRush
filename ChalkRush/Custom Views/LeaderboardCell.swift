//
//  LeaderboardCell.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 22.02.2024.
//

import UIKit

class LeaderboardCell: UITableViewCell {

    static let identifier = "LeaderboardCell"
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel.createLabel(text: "")
    private let dateLabel = UILabel.createLabel(text: "")
    private let scoreLabel = UILabel.createLabel(text: "")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .background
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(scoreLabel)

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = UIFont(name: Fonts.chalkduster.rawValue, size: FontSizes.smallLabel.rawValue)
        scoreLabel.font = UIFont(name: Fonts.chalkduster.rawValue, size: FontSizes.scoreLabel.rawValue)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),

            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with score: Score) {
        avatarImageView.image = loadImage(from: score.player.avatarImagePath)
        nameLabel.text = score.player.name
        dateLabel.text = formatDate(score.date)
        scoreLabel.text = "\(score.score)"
    }

    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        return dateFormatter.string(from: date)
    }

    private func loadImage(from fileName: String) -> UIImage {
        return DataManager.loadImage(from: fileName)
    }
}


