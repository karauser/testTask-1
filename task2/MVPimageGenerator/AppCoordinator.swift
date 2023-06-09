//
//  AppCoordinator.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//

import UIKit

final class AppCoordinator {
    
    private let networkService = NetworkService()
    private let storageManager = StorageManager()
    
    public func create() -> UITabBarController {
        
        let mainViewController = MainViewController()
        let favoritesViewController = FavoritesViewController()
        let transformer = ImageDataTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "ImageDataTransformer"))
        let mainPresenter = MainPresenter(networkService: networkService, storageManager: storageManager)
        mainPresenter.view = mainViewController
        let favoritesPresenter = FavoritesPresenter(storageManager: storageManager)
        favoritesPresenter.view = favoritesViewController
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [mainViewController, favoritesViewController]
        mainViewController.presenter = mainPresenter
        favoritesViewController.presenter = favoritesPresenter
        
        mainViewController.tabBarItem = UITabBarItem(title: "Main", image: nil, tag: 0)
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: nil, tag: 1)
        favoritesViewController.tabBarItem.accessibilityIdentifier = "FavoritesTab"
        
        
        tabBarController.viewControllers = [mainViewController, favoritesViewController]
        return tabBarController
    }
}

