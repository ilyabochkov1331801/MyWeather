//
//  ApiModelErrors.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum ApiModelErrors: Error {
    case URLComponentsError
    case CoordinatesError
    case StatusError(code: Int)
}
