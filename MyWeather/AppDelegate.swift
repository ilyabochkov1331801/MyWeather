//
//  AppDelegate.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        let commonForecastTableViewController = CommonForecastTableViewController()
        let commonForecastNavigationController = UINavigationController(rootViewController: commonForecastTableViewController)
        commonForecastNavigationController.tabBarItem = UITabBarItem(title: "Common forecast", image: UIImage(systemName: "thermometer"), tag: 0)
        tabBarController.viewControllers = [ commonForecastNavigationController ]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

