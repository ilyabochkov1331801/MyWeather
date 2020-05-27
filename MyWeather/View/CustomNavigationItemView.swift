//
//  CustomNavigationItemView.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class CustomNavigationItemView: UIView {
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    func commonInit() {
        let bundle = Bundle(for: CustomNavigationItemView.self)
        bundle.loadNibNamed("CustomNavigationItemView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
        spinnerView.hidesWhenStopped = true
        cityNameLabel.adjustsFontSizeToFitWidth = true
    }
        
    func startUpdating() {
        sunsetTimeLabel.text = nil
        sunriseTimeLabel.text = nil
        cityNameLabel.text = nil
        spinnerView.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func updateData(sunriseTime: Int, cityName: String, sunsetTime: Int) {
        sunsetTimeLabel.text = convertTime(from: sunsetTime)
        sunriseTimeLabel.text = convertTime(from: sunriseTime)
        cityNameLabel.text = cityName
        spinnerView.stopAnimating()
    }
    
    func convertTime(from: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(from))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

