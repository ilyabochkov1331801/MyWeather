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
    func apiMessage(with coordinates: CLLocationCoordinate2D?) -> (ApiMessage?, Error?) {
        
        guard let coordinates = coordinates else {
            return (nil, ApiModelErrors.CoordinatesError)
        }
        var apiURLComponents = URLComponents(string: ApiModel.apiURL)
        
        apiURLComponents?.queryItems = [
            URLQueryItem(name: "lat", value: String(coordinates.latitude)),
            URLQueryItem(name: "lon", value: String(coordinates.longitude)),
            URLQueryItem(name: "appid", value: ApiModel.key)
        ]
        
        guard let url = apiURLComponents?.url else {
            return (nil, ApiModelErrors.URLComponentsError)
        }
        
        var message: ApiMessage?
        var urlSessionError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        
        let urlSessionDataTask = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                urlSessionError = error
            } else if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...300:
                    break
                default:
                    urlSessionError = ApiModelErrors.StatusError(code: response.statusCode)
                }
            }
            if let data = data {
                message = try? JSONDecoder().decode(ApiMessage.self, from: data)
            }
            semaphore.signal()
        }
        urlSessionDataTask.resume()
        semaphore.wait()
        return (message, urlSessionError)
    }
}
