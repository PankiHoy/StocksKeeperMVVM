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
        
        let mainController = UINavigationController(rootViewController: router.createMainModule())
        let bagsController = UINavigationController(rootViewController: router.createBagsModule())
        
        tabBarController.viewControllers = [mainController, bagsController]
        
        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

