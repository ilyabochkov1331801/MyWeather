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
    
    func updateForecast(with coordinates: CLLocationCoordinate2D?, error: Error?) {
        guard error == nil else  {
            delegate?.updateForecast(with: nil, error: error)
            return
        }
        apiModel.apiMessage(with: coordinates) {
            [weak self] (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self?.delegate?.updateForecast(with: nil, error: error)
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self?.delegate?.updateForecast(with: nil, error: ApiModelErrors.ResponseError)
                }
                return
            }
            switch response.statusCode {
            case 200...300:
                if let data = data, let apiMessage = try? JSONDecoder().decode(ApiMessage.self, from: data) {
                    DispatchQueue.main.async {
                        self?.delegate?.updateForecast(with: apiMessage, error: nil)
                    }
                }
            default:
                DispatchQueue.main.async {
                    self?.delegate?.updateForecast(with: nil, error: ApiModelErrors.StatusError(code: response.statusCode))
                }
            }
        }
    }
    
    func updateForecast(with cityName: String?) {
        guard let cityName = cityName else {
            delegate?.updateForecast(with: nil, error: ApiModelErrors.WrongPlace)
            return
        }
        CLGeocoder().geocodeAddressString(cityName) {
            [weak self] (placeMarks, error) in
            if let cityLocationCoordinates = placeMarks?.first?.location?.coordinate {
                self?.updateForecast(with: CLLocationCoordinate2D(
                    latitude: round(cityLocationCoordinates.latitude),
                    longitude: round(cityLocationCoordinates.latitude)), error: error)
            }
        }
    }
}


extension Double {
    func round(_ number: Double?) -> Double? {
        guard let number = number else {
            return nil
        }
        return (number * 100.0).rounded() / 100.0
    }
}
