//
//  ApiModel.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import CoreLocation

class ApiModel {
    private static let apiURL = "https://api.openweathermap.org/data/2.5/forecast?"
    private static let key = "2a6938098eb62bba02708327e9d0194e"
    
    func apiMessage(with coordinates: CLLocationCoordinate2D?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let coordinates = coordinates else {
            completionHandler(nil, nil, ApiModelErrors.CoordinatesError)
            return
        }
        var apiURLComponents = URLComponents(string: ApiModel.apiURL)
        apiURLComponents?.queryItems = [
            URLQueryItem(name: "lat", value: String(coordinates.latitude)),
            URLQueryItem(name: "lon", value: String(coordinates.longitude)),
            URLQueryItem(name: "appid", value: ApiModel.key)
        ]
        guard let url = apiURLComponents?.url else {
            completionHandler(nil, nil, ApiModelErrors.URLComponentsError)
            return
        }
        let urlSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        urlSessionDataTask.resume()
    }
}
