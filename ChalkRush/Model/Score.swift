//
//  Score.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 20.02.2024.
//

import Foundation

struct Score: Codable {
    var player: Player
    var score: Int
    var date: Date
}
