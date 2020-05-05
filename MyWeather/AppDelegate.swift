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
        commonForecastNavigationController.tabBarItem = UITabBarItem(title: "Forecast", image: UIImage(systemName: "thermometer"), tag: 0)
        commonForecastNavigationController.navigationBar.backgroundColor = UIColor(red: 0.121569, green: 0.129412, blue: 0.341176, alpha: 1)
        tabBarController.tabBar.backgroundColor = UIColor(red: 0.121569, green: 0.129412, blue: 0.441176, alpha: 1)
        tabBarController.viewControllers = [ commonForecastNavigationController ]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

