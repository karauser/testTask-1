//
//  FavoritesPresenter.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//

import UIKit

protocol FavoritesViewOutput: AnyObject {
    func getFavoritesCount() -> Int
    func getFavorite(at index: Int) -> FavoriteImageModel
    func removeFavorite(at index: Int)
    func addToFavorites(_ image: UIImage, query: String)
}

class FavoritesPresenter: FavoritesViewOutput {
    
    weak var view: FavoritesViewInput?
    private let storageManager: StorageManager
    private let favoritesLimit = 10
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func getFavoritesCount() -> Int {
        return storageManager.getFavoriteImages().count
    }
    
    func getFavorite(at index: Int) -> FavoriteImageModel {
        let favorites = storageManager.getFavoriteImages()
        return favorites[index]
    }
    
    func addToFavorites(_ image: UIImage, query: String) {
        storageManager.saveImage(image, query: query)
    }
    
    func removeFavorite(at index: Int) {
        storageManager.removeFavorite(at: index)
    }
}
