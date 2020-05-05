//
//  AccurateForecastPageViewController.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/5/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class AccurateForecastPageViewController: UIPageViewController {
    
    let forecast: Forecast?
    
    init(forecast: Forecast?) {
        self.forecast = forecast
        super.init(transitionStyle: .pageCurl, navigationOrientation: .vertical, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
}

extension AccurateForecastPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

