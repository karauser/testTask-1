//
//  AppDelegate.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
  
        let appCoordinator = AppCoordinator()
        let initialViewController = appCoordinator.create()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
