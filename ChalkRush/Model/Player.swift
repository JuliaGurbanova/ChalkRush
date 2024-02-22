//
//  Player.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

struct Player: Codable {
    var id = UUID()
    var name: String = "Unknown"
    var avatarImagePath: String = "avatarPlaceholder"
    var gameSettings: GameSettings = GameSettings()
}
