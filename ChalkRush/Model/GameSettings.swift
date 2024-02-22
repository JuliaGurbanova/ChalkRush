//
//  GameSettings.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

class GameSettings: Codable {
    var selectedCarIndex: Int = 0
    var difficultyLevelIndex = DifficultyLevel.medium.rawValue
}
