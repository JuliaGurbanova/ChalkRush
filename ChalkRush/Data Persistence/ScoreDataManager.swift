//
//  ScoreDataManager.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 20.02.2024.
//

import Foundation

struct ScoreDataManager {
    static let scoresFilePath = DataManager.documentsDirectory.appendingPathComponent("ScoresData", conformingTo: .json)
    
    static func saveScore(_ score: Score) {
        var scores = loadScores()
        scores.append(score)
        saveScores(scores)
    }

    static func loadScores() -> [Score] {
        if let scoreData = try? Data(contentsOf: scoresFilePath) {
            if let scores = try? JSONDecoder().decode([Score].self, from: scoreData) {
                return scores
            }
        }
        return []
    }

    static func saveScores(_ scores: [Score]) {
        let encoder = JSONEncoder()
        do {
            let scoreData = try encoder.encode(scores)
            try scoreData.write(to: scoresFilePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving game scores: \(error.localizedDescription)")
        }
    }
}
