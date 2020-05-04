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
    let forecast: Forecast?
    let iconModel: IconModel
    
    init(forecast: Forecast?) {
        self.forecast = forecast
        iconModel = IconModel(iconCode: forecast?.weather.first?.icon)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = iconModel.iconPicture()
    }
}
