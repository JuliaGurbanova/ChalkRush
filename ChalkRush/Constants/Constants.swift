//
//  Constants.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

// UI

enum Fonts: String {
    case chalkduster = "Chalkduster"
}

enum FontSizes: CGFloat {
    case buttonTitle = 28.0
    case label = 18.0
    case smallLabel = 14.0
    case segmentedControl = 16.0
    case countdown = 130.0
    case scoreLabel = 30.0
}

// Game Settings

enum Cars{
    static let car1 = UIImage(resource: .car1)
    static let car2 = UIImage(resource: .car2)
    static let car3 = UIImage(resource: .car3)
    static let car4 = UIImage(resource: .car4)
}

enum CarSize {
    static let carWidth: CGFloat = 70.0
    static let carHeight: CGFloat = 130.0
}

enum DifficultyLevel: Int {
    case easy
    case medium
    case hard
}

// Obstacles

let obstacleTypes = ["npcCar1", "npcCar2", "npcCar3", "tyre", "cone"]

enum Obstacles: String {
    case npcCar
    case tyre = "tyre"
    case cone = "cone"
}

enum ObstacleSizes: Int {
    case npcCarWidth = 90
    case npcCarHeight = 140

    case coneWidth = 50
    case coneHeight = 80

    case tyre = 70
}

enum ObstacleGenerationIntervals {
    static let easy: TimeInterval = 2.0
    static let medium: TimeInterval = 1.0
    static let hard: TimeInterval = 0.5
}

enum CountdownSetup {
    static let startingNumber = 3
    static let duration: TimeInterval = 0.8
    static let labelScale: CGFloat = 2.0
}


