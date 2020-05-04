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
    private(set) var location: CLLocation? {
        didSet {
            let apiModelResult = apiModel.apiMessage(with: location?.coordinate)
            delegate?.updateForecast(with: apiModelResult.0, error: apiModelResult.1)
        }
    }

    init() {
        apiModel = ApiModel()
    }
    
    func updateLocation(with location: CLLocation?) {
        self.location = location
    }
}
