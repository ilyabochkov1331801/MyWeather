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
        //  Не заходит в CLGeocodeCompletionHandler и, соответственное, стоит на семафоре
        geoCoder.geocodeAddressString(cityName) {
            (placeMarks, error) in
            if let error = error {
                geoCoderError = error
            } else {
                coordinates = placeMarks?.first?.location?.coordinate
            }
            semaphore.signal()
        }
        semaphore.wait()
        return (coordinates, geoCoderError)
    }
}
