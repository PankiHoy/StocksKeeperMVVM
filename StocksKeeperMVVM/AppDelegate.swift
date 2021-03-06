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
    var router: ModuleBuilderProtocol!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tabBarController = UITabBarController()
        router = ModuleBuilder()
        
        let mainController = UINavigationController(rootViewController: router.createMainModule())
        let bagsController = UINavigationController(rootViewController: router.createBagsModule())
        mainController.navigationBar.tintColor = .black
        bagsController.navigationBar.tintColor = .black
        
        tabBarController.viewControllers = [mainController, bagsController]
        tabBarController.tabBar.tintColor = .black
        
        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

