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
    private let networkService: NetworkProtocol
    private let storageManager: StorageManager
    private var addToFavoritesClosure: ((UIImage, String) -> Void)?
    private var requestIdentifiers: [String: (Result<UIImage, Error>) -> Void] = [:]
    weak var view: MainViewInput?
    
    init(networkService: NetworkProtocol, storageManager: StorageManager) {
        self.networkService  = networkService
        self.storageManager = storageManager
    }
    
    func generateButtonTapped() {
        guard let image = view?.getGeneratedImage() else { return }
        view?.showGeneratedImage(image)
    }
    
    func favoriteButtonTapped() {
        addToFavorites()
    }
    
    func generateImage(with query: String) {
        networkService.generateImage(with: query) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.view?.showGeneratedImage(image)
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
            storageManager.saveImage(image, query: query)
            view?.imageSavedToFavorites()
        }
    }
}

