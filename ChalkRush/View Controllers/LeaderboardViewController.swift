//
//  LeaderboardViewController.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

class LeaderboardViewController: UITableViewController {

    var scores: [Score] = []
    let rowHeight: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .background

        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: LeaderboardCell.identifier)
        loadScores()
    }

    private func loadScores() {
        scores = ScoreDataManager.loadScores()
        scores.sort { $0.score > $1.score }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardCell.identifier, for: indexPath) as? LeaderboardCell else {
            return UITableViewCell()
        }

        let score = scores[indexPath.row]
        cell.configure(with: score)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .background
        let label = UILabel.createLabel(text: "Score")

        headerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Paddings.standard),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            scores.remove(at: indexPath.row)
            ScoreDataManager.saveScores(scores)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

