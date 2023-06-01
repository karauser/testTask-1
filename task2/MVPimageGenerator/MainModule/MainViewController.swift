//
//  ViewController.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//

import UIKit

protocol MainViewInput: AnyObject {
    func showGeneratedImage(_ image: UIImage)
    func getGeneratedImage() -> UIImage?
    func updateFavoriteButtonState()
    func getQueryText() -> String?
    func showAlert(with error: Error)
    func imageSavedToFavorites()
    
}

class MainViewController: UIViewController, MainViewInput {
    
    var presenter: MainViewOutput?
    
    private var textField: UITextField!
    private var generateButton: UIButton!
    private var imageView: UIImageView!
    private var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.onViewDidLoad()
        setupKeyboard()
    }
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        textField.delegate = self
        textField.returnKeyType = .done
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        textField = UITextField(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40))
        textField.borderStyle = .roundedRect
        textField.accessibilityIdentifier = AccessibilityIdentifier.textfield
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.addSubview(textField)
        
        generateButton = UIButton(type: .system)
        generateButton.frame = CGRect(x: 20, y: 150, width: view.frame.width - 40, height: 40)
        generateButton.setTitle("Generate", for: .normal)
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        generateButton.isEnabled = false
        generateButton.accessibilityIdentifier = AccessibilityIdentifier.generateButton
        view.addSubview(generateButton)
        
        imageView = UIImageView(frame: CGRect(x: 20, y: 200, width: view.frame.width - 40, height: view.frame.width - 40))
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = AccessibilityIdentifier.imageView
        view.addSubview(imageView)
        
        favoriteButton = UIButton(type: .system)
        favoriteButton.frame = CGRect(x: 20, y: 180 + view.frame.width, width: view.frame.width - 40, height: 40)
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.isEnabled = false
        favoriteButton.accessibilityIdentifier = AccessibilityIdentifier.favoriteButton
        view.addSubview(favoriteButton)
    }
    
    @objc private func generateButtonTapped() {
        if let text = textField.text, !text.isEmpty {
            presenter?.generateImage(with: text)
        }
    }
    
    @objc private func favoriteButtonTapped() {
        presenter?.addToFavorites()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateGenerateButtonState()
    }
    
    func getGeneratedImage() -> UIImage? {
        return imageView.image
    }
    
    func getQueryText() -> String? {
        return textField.text
    }
    
    func showGeneratedImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func updateFavoriteButtonState() {
        favoriteButton.isEnabled = true
    }
    
    func updateGenerateButtonState() {
        generateButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imageSavedToFavorites() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Успешно", message: "Изображение добавлено в избранное", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        generateButtonTapped()
        return true
    }
}
