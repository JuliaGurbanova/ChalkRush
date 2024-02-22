//
//  UsernameTextField.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

class UsernameTextField: UITextField {

    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .background

        textColor = .white
        tintColor = .background
        font = UIFont(name: Fonts.chalkduster.rawValue, size: FontSizes.label.rawValue)

        autocorrectionType = .no
        keyboardAppearance = .dark
        returnKeyType = .done
        clearButtonMode = .whileEditing
        attributedPlaceholder = NSAttributedString(
            string: "Your Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
    }
}
