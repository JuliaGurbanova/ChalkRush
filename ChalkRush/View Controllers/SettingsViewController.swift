//
//  SettingsViewController.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate {

    lazy var player = DataManager.load()
    var gameSettings = GameSettings()
    var selectedAvatar: UIImage?

    private var hasDataChanged = false
    private var hasAvatarChanged = false

    //  MARK: - UI Elements
    let avatarImageView = UIImageView()
    let avatarPromptLabel = UILabel.createLabel(text: "Tap to select an avatar")
    let nameLabel = UILabel.createLabel(text: "Enter your name:")
    let nameTextField = UsernameTextField()
    let carPromptLabel = UILabel.createLabel(text: "Select your car:")
    let carSegmentedControl = UISegmentedControl(items: ["Car 1", "Car 2", "Car 3", "Car 4"])
    let difficultyPromptLabel = UILabel.createLabel(text: "Choose the difficulty:")
    let difficultySegmentedControl = UISegmentedControl(items: ["easy", "medium", "hard"])

    let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        setupUI()

        nameTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if hasDataChanged || hasAvatarChanged {
            saveUserData()
        }
    }

    // MARK: - UI setup
    private func setupUI() {
        // Avatar Image View

        if player.avatarImagePath != "avatarPlaceholder" {
            avatarImageView.image = DataManager.loadImage(from: player.avatarImagePath)
        }
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = ImageFrame.cornerRadius
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = ImageFrame.borderWidth
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageViewTapped))
        avatarImageView.addGestureRecognizer(tapGesture)

        // Avatar Prompt Label
        avatarPromptLabel.textAlignment = .center
        avatarPromptLabel.font = UIFont(name: Fonts.chalkduster.rawValue, size: FontSizes.smallLabel.rawValue)

        // Name Text Field
        if player.name != "Unknown" {
            nameTextField.text = player.name
        }

        // Car Segmented Control
        carSegmentedControl.selectedSegmentIndex = player.gameSettings.selectedCarIndex
        carSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        carSegmentedControl.addTarget(self, action: #selector(carSegmentedControlValueChanged), for: .valueChanged)

        // Car Image View
        carImageView.image = UIImage(named: "car\(player.gameSettings.selectedCarIndex + 1)")

        // Difficulty Segmented Control
        difficultySegmentedControl.selectedSegmentIndex = player.gameSettings.difficultyLevelIndex
        difficultySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        difficultySegmentedControl.addTarget(self, action: #selector(difficultySegmentedControlValueChanged), for: .valueChanged)

        // Add subviews
        view.addSubviews(
            avatarImageView,
            avatarPromptLabel,
            nameLabel,
            nameTextField,
            carPromptLabel,
            carSegmentedControl,
            carImageView,
            difficultyPromptLabel,
            difficultySegmentedControl
        )

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: ImageFrame.size),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: ImageFrame.size),
            avatarImageView.heightAnchor.constraint(equalToConstant: ImageFrame.size),

            avatarPromptLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Paddings.small),
            avatarPromptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),
            avatarPromptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.settingsPadding),

            nameLabel.topAnchor.constraint(equalTo: avatarPromptLabel.bottomAnchor, constant: Paddings.settingsPadding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Paddings.small),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.settingsPadding),

            carPromptLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Paddings.settingsPadding),
            carPromptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),
            carPromptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.settingsPadding),

            carSegmentedControl.topAnchor.constraint(equalTo: carPromptLabel.bottomAnchor, constant: Paddings.settingsPadding),
            carSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),
            carSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.settingsPadding),

            carImageView.topAnchor.constraint(equalTo: carSegmentedControl.bottomAnchor, constant: Paddings.settingsPadding),
            carImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carImageView.widthAnchor.constraint(equalToConstant: ImageFrame.size),
            carImageView.heightAnchor.constraint(equalToConstant: ImageFrame.size),

            difficultyPromptLabel.topAnchor.constraint(equalTo: carImageView.bottomAnchor, constant: Paddings.settingsPadding),
            difficultyPromptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),

            difficultySegmentedControl.topAnchor.constraint(equalTo: difficultyPromptLabel.bottomAnchor, constant: Paddings.settingsPadding),
            difficultySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.settingsPadding),
            difficultySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.settingsPadding)
        ])
    }


    // MARK: - Actions

    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }

    @objc func avatarImageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        let alert = UIAlertController(title: "Choose Photo Source", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    @objc func carSegmentedControlValueChanged() {
        let selectedCarImageName = "car\(carSegmentedControl.selectedSegmentIndex + 1)"
        carImageView.image = UIImage(named: selectedCarImageName)
        hasDataChanged = true
    }

    @objc func difficultySegmentedControlValueChanged() {
        hasDataChanged = true
    }

    // MARK: - Saving and loading data
    private func saveUserData() {
        player.name = nameTextField.text ?? "Unknown"
        if hasAvatarChanged {
            player.avatarImagePath = saveAvatarImage()
        }

        player.gameSettings.selectedCarIndex = carSegmentedControl.selectedSegmentIndex
        player.gameSettings.difficultyLevelIndex = difficultySegmentedControl.selectedSegmentIndex

        DataManager.save(player)

        hasAvatarChanged = false
        hasDataChanged = false
    }

    private func saveAvatarImage() -> String {
        guard let selectedAvatar = selectedAvatar else {
            return "avatarPlaceholder"
        }

        do {
            return try DataManager.saveImage(selectedAvatar) ?? "avatarPlaceholder"
        } catch {
            print("Error saving avatar image: \(error.localizedDescription)")
            return "avatarPlaceholder"
        }
    }
}

// MARK: - Text Field Delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hasDataChanged = true
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            avatarImageView.image = editedImage
            selectedAvatar = editedImage
            hasAvatarChanged = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            avatarImageView.image = originalImage
            selectedAvatar = originalImage
            hasAvatarChanged = true
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
