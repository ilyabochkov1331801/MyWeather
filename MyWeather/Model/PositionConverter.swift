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
    func convertToLocation(with cityName: String) -> (CLLocationCoordinate2D?, Error?) {
        let geoCoder = CLGeocoder()
        var geoCoderError: Error?
        var coordinates: CLLocationCoordinate2D?
        let semaphore = DispatchSemaphore(value: 0)
        geoCoder.geocodeAddressString(cityName) {
            (placeMarks, error) in
            if let error = error {
                geoCoderError = error
            } else {
                let buf = placeMarks?.first?.location?.coordinate
                coordinates = buf
            }
            semaphore.signal()
        }
        semaphore.wait()
        return (coordinates, geoCoderError)
    }
}
