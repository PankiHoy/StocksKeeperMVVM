//
//  AppDelegate.swift
//  StocksKeeper
//
//  Created by dev on 6.10.21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: ModuleBuilder!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tabBarController = UITabBarController()
        router = ModuleBuilder()
        
        let mainController = router.createMainModule()
        let stocksController = router.createMainModule()
        
        tabBarController.viewControllers = [mainController, stocksController]
        
        let navigationController = UINavigationController(rootViewController: mainController)
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

