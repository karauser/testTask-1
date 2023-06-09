//
//  MVPimageGeneratorUITests.swift
//  MVPimageGeneratorUITests
//
//  Created by Sergey on 25/05/23.
//

import XCTest

class MainViewControllerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testImageGeneration() {
        // Вводим значение "TestQuery" в текстовое поле
        let queryTextField = app.textFields["QueryTextField"]
        queryTextField.tap()
        queryTextField.typeText("TestQuery")

        app.buttons["Done"].tap()
        
        // Проверяем, что текстовое поле содержит значение "TestQuery"
        XCTAssertEqual(queryTextField.value as? String, "TestQuery")

        // Нажимаем на кнопку "Generate Image"
        let generateButton = app.buttons["GenerateButton"]
        generateButton.tap()

        // Проверяем, что появилось представление с сгенерированной картинкой
        let generatedImageView = app.images["Image"]
        XCTAssertTrue(generatedImageView.exists)

        // Проверяем, что появилась кнопка "Add to Favorites"
        let addToFavoritesButton = app.buttons["FavoriteButton"]
        XCTAssertTrue(addToFavoritesButton.exists)

        // Нажимаем на кнопку "Add to Favorites"
        addToFavoritesButton.tap()

        // Проверяем, что появился алерт с сообщением об успешном добавлении в избранное
        let alert = app.alerts.element
        XCTAssertEqual(alert.staticTexts["Успешно"].label, "Успешно")
        
        // Нажимаем на кнопку "OK" в алерте
        let okButton = alert.buttons["OK"]
        okButton.tap()

        // Проверяем, что алерт исчез
        XCTAssertFalse(alert.exists)

        // Проверяем, что добавленная картинка отображается в списке избранных
        let favoritesTab = app.tabBars.buttons["FavoritesTab"]
        favoritesTab.tap()

        let tableView = app.tables["FavoritesTableView"]
            XCTAssertTrue(tableView.cells.count == 1)
            
            // Удаляем элемент
            let favoriteCell = tableView.cells.element(boundBy: 0)
            favoriteCell.swipeLeft()
            tableView.buttons["Delete"].tap()
      
            // Проверяем, что элемент удален из таблицы
            XCTAssertTrue(tableView.cells.count == 0)
    }
}
