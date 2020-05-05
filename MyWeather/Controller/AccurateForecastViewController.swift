//
//  AccurateForecastViewController.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class AccurateForecastViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    let forecast: Forecast?
    let iconModel: IconModel
    let titleLabel: UILabel
    
    init(forecast: Forecast?) {
        self.forecast = forecast
        iconModel = IconModel(iconCode: forecast?.weather.first?.icon)
        titleLabel = UILabel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = iconModel.iconPicture()
        temperatureLabel.text = TemperatureConverter.convertTemperature(from: forecast?.main.temp) + " / " + TemperatureConverter.convertTemperature(from: forecast?.main.feels_like)
        windLabel.text = String(format:"%.2f", forecast!.wind.speed) + " m/s"
        titleLabel.font = UIFont(name: "Noteworthy Light", size: 20)
        titleLabel.textColor = windLabel.textColor
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = forecast?.dt_txt
        navigationItem.titleView = titleLabel
    }
}
