//
//  Forecast.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ForecastModel {
    var delegate: ForecastModelDelegate?
    private let apiModel: ApiModel
    
    init() {
        apiModel = ApiModel()
    }
    
    func updateForecast(with coordinates: CLLocationCoordinate2D?) {
        let apiModelResult = apiModel.apiMessage(with: coordinates)
        delegate?.updateForecast(with: apiModelResult.0, error: apiModelResult.1)
    }
    
    func updateForecast(with cityName: String) {
        let positionConverter = PositionConverter()
        let positionConvertResult = positionConverter.convertToLocation(with: cityName)
        if let error = positionConvertResult.1 {
            delegate?.updateForecast(with: nil, error: error)
        } else {
            updateForecast(with: positionConvertResult.0)
        }
    }
}
