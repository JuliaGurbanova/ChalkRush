//
//  UILabel+Extension.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

extension UILabel {
    static func createLabel(text: String) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: Fonts.chalkduster.rawValue, size: FontSizes.label.rawValue)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
