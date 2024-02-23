//
//  DataManager.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

struct DataManager {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static let filePath = documentsDirectory.appendingPathComponent("PlayerData", conformingTo: .json)

    static func save(_ player: Player) {
        let encoder = JSONEncoder()
        do {
            let playerData = try encoder.encode(player)
            try playerData.write(to: filePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving player data: \(error.localizedDescription)")
        }
//        print(documentsDirectory)
    }

    static func load() -> Player {
        if let playerData = try? Data(contentsOf: filePath) {
            if let decodedPlayer = try? JSONDecoder().decode(Player.self, from: playerData) {
                return decodedPlayer
            }
        }
        return Player()
    }

    // MARK: - Save and load avatar image
    static func saveImage(_ image: UIImage) throws -> String? {
        let name = UUID().uuidString
        let imageFileURL = documentsDirectory.appendingPathComponent(name, conformingTo: .jpeg)

        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        try data.write(to: imageFileURL)
        return name
    }

    static func loadImage(from fileName: String) -> UIImage {
        let imageFileURL = documentsDirectory.appendingPathComponent(fileName, conformingTo: .jpeg)
        if let image = UIImage(contentsOfFile: imageFileURL.path) {
            return image
        }
        return UIImage(resource: .avatarPlaceholder)
    }
}
