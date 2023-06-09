//
//  MVPimageGeneratorTests.swift
//  MVPimageGeneratorTests
//
//  Created by Sergey on 25/05/23.
//

import XCTest

@testable import MVPimageGenerator

class FavoriteManagerTests: XCTestCase {
    
    var favoriteManager: StorageManager!

    override func setUpWithError() throws {
        // Создаем экземпляр FavoriteManager перед каждым тестом
        favoriteManager = StorageManager()
        
        // Очищаем предыдущие избранные картинки перед каждым тестом
        for _ in 1...10 {
            favoriteManager.removeOldestFavoriteImage()
        }
    }

    override func tearDownWithError() throws {
        // Очищаем избранные картинки после каждого теста
        for _ in 1...10 {
            favoriteManager.removeOldestFavoriteImage()
        }
    }

    func testAddingAndRemovingFavorites() throws {
        // Добавляем 10 тестовых картинок
        for i in 1...10 {
            let bundle = Bundle(for: type(of: self))
            let imagePath = bundle.path(forResource: "test_image", ofType: "png")
            let image = UIImage(contentsOfFile: imagePath!)
            let query = "Test Query \(i)"
            favoriteManager.saveImage(image!, query: query)
        }
        
        // Проверяем, что количество избранных картинок равно 10
        XCTAssertEqual(favoriteManager.getFavoriteImages().count, 10)
        
        // Добавляем 11-ю тестовую картинку
        let bundle = Bundle(for: type(of: self))
        let imagePath = bundle.path(forResource: "test_image", ofType: "png")
        let image = UIImage(contentsOfFile: imagePath!)
        let newQuery = "New Test Query"
        favoriteManager.saveImage(image!, query: newQuery)
        
        // Проверяем, что количество избранных картинок после добавления новой равно 10
        XCTAssertEqual(favoriteManager.getFavoriteImages().count, 10)
        
        // Проверяем, что первая картинка была удалена
        let favorites = favoriteManager.getFavoriteImages()
        XCTAssertFalse(favorites.contains { $0.query == "Test Query 1" })
        
        // Проверяем, что 11-я картинка стала 10-й
        XCTAssertTrue(favorites.contains { $0.query == "New Test Query" })
    }

}

