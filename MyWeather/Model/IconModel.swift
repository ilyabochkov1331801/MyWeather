//
//  IconModel.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class IconModel {
    private let iconCode: String
    private static let url = "http://openweathermap.org/img/wn/"
    init(iconCode: String?) {
        self.iconCode = iconCode ?? ""
    }
    func iconPicture() -> UIImage? {
        guard let iconURL = URL(string: IconModel.url + iconCode + "@2x.png") else {
            return nil
        }
        guard let data = try? Data(contentsOf: iconURL) else {
            return nil
        }
        return UIImage(data: data)
    }
}

