//
//  TemperatureConverter.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class TemperatureConverter {
    static func convertTemperature(from kelvin: Double?) -> String {
        guard let kelvin = kelvin else {
            return "No data"
        }
        return String(format:"%.2f", kelvin - 273.1) + " ℃"
    }
}
