//
//  PositionConverter.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/6/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import CoreLocation

class PositionConverter {
    func convertToLocation(with cityName: String, completionHandler: @escaping ([CLPlacemark]?, Error?) -> Void){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityName, completionHandler: completionHandler)
    }
}
