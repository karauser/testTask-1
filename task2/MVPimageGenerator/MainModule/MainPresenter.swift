//
//  MainPresenter.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//

import UIKit

protocol MainViewOutput: AnyObject {
    func onViewDidLoad()
    func generateImage(with query: String)
    func addToFavorites()
    func generateButtonTapped()
    func favoriteButtonTapped()
    
}

class MainPresenter: MainViewOutput {
    func onViewDidLoad() {}
    private let imageService: NetworkProtocol
    private let favoriteManager: StorageManager
    private var addToFavoritesClosure: ((UIImage, String) -> Void)?
    private var inputText = [String]()
    weak var view: MainViewInput?
    
    init(imageService: NetworkProtocol, favoriteManager: StorageManager) {
        self.imageService    = imageService
        self.favoriteManager = favoriteManager
    }
    
    func generateButtonTapped() {
        guard let image = view?.getGeneratedImage() else { return }
        view?.showGeneratedImage(image)
    }
    
    func favoriteButtonTapped() {
        addToFavorites()
    }
    
    func generateImage(with query: String) {
        guard !inputText.contains(query) else { return }
        imageService.generateImage(with: query) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.view?.showGeneratedImage(image)
                    self?.inputText.append(query)
                    self?.view?.updateFavoriteButtonState()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showAlert(with: error)
                }
            }
        }
    }
    
    func addToFavorites() {
        if let image = view?.getGeneratedImage(), let query = view?.getQueryText() {
            favoriteManager.saveImage(image, query: query)
            view?.imageSavedToFavorites()
        }
    }
}

