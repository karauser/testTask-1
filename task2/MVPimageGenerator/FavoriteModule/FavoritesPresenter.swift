//
//  FavoritesPresenter.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//

import UIKit

protocol FavoritesViewOutput: AnyObject {
    func getFavoritesCount() -> Int
    func getFavorite(at index: Int) -> Favorite
    func removeFavorite(at index: Int)
    func addToFavorites(_ image: UIImage, query: String)
}

class FavoritesPresenter: FavoritesViewOutput {
    
    weak var view: FavoritesViewInput?
    private let favoriteManager: StorageManager
    private let favoritesLimit = 10
    
    init(favoriteManager: StorageManager) {
        self.favoriteManager = favoriteManager
    }
    
    func getFavoritesCount() -> Int {
        return favoriteManager.getFavoriteImages().count
    }
    
    func getFavorite(at index: Int) -> Favorite {
        let favorites = favoriteManager.getFavoriteImages()
        return favorites[index]
    }
    
    func addToFavorites(_ image: UIImage, query: String) {
        favoriteManager.saveImage(image, query: query)
    }
    
    func removeFavorite(at index: Int) {
        favoriteManager.removeFavorite(at: index)
    }
}
