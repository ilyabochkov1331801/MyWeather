//
//  ApiMessage.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct ApiMessage: Codable {
    let city: City
    let list: Array<Forecast>
}

struct City: Codable {
    let name: String
    let sunrise: Int
    let sunset: Int
}

struct Forecast: Codable {
    let main: Main
    let weather: Array<Weather>
    let clouds: Clouds
    let wind: Wind
    let dt_txt: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}
