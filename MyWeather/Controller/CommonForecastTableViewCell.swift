//
//  CommonForecastTableViewCell.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class CommonForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateData(time: String?, temperature: Double?, weatherDescription: String?) {
        timeLabel.text = time
        temperatureLabel.text = "\(convertTemperature(from: temperature))"
        weatherDescriptionLabel.text = weatherDescription
    }
    
    func convertTemperature(from kelvin: Double?) -> String {
        guard let kelvin = kelvin else {
            return "No data"
        }
        return String(format:"%.2f", kelvin - 273.1)
    }
}
