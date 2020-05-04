//
//  ForecastDelegate.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

protocol ForecastModelDelegate {
    func updateForecast(with apiMessage: ApiMessage?, error: Error?)
}
