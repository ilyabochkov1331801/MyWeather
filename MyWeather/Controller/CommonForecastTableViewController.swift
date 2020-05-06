//
//  CommonForecastTableViewController.swift
//  MyWeather
//
//  Created by Илья Бочков  on 5/4/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import CoreLocation

class CommonForecastTableViewController: UITableViewController {
    
    private let forecastModel = ForecastModel()
    private let locationManager = CLLocationManager()
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private var apiMessage: ApiMessage?
    private var location: CLLocation?
    private var customNavigationItemView: CustomNavigationItemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastModel.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tableView.register(UINib(nibName: "CommonForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "CommonForecastTableViewCell")
        tableView.rowHeight = 60
        spinnerView.hidesWhenStopped = true
        navigationItem.titleView = spinnerView
        spinnerView.startAnimating()
        customNavigationItemView = CustomNavigationItemView()
        customNavigationItemView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        navigationItem.titleView = customNavigationItemView
        let navigationItemTupGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigationItemTupped(param:)))
        navigationItemTupGestureRecognizer.delegate = self
        customNavigationItemView.addGestureRecognizer(navigationItemTupGestureRecognizer)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiMessage?.list.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonForecastTableViewCell", for: indexPath) as! CommonForecastTableViewCell
        cell.updateData(time: apiMessage?.list[indexPath.row].dt_txt,
                        temperature: apiMessage?.list[indexPath.row].main.temp,
                        weatherDescription: apiMessage?.list[indexPath.row].weather.first?.description)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accurateForecastViewController = AccurateForecastViewController(forecast: apiMessage?.list[indexPath.row])
        navigationController?.pushViewController(accurateForecastViewController, animated: true)
    }
}

extension CommonForecastTableViewController: ForecastModelDelegate {
    
    func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let reloadAlertAction = UIAlertAction(title: "Reload", style: .default, handler: {
            [weak self] (_) in
            self?.locationManager.requestLocation()
        })
        alert.addAction(reloadAlertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateForecast(with apiMessage: ApiMessage?, error: Error?) {
        guard error == nil else {
            showAlert(with: error!)
            return
        }
        guard let apiMessage = apiMessage else {
            return
        }
        (navigationItem.titleView as! CustomNavigationItemView).updateData(sunriseTime: apiMessage.city.sunrise,
                                            cityName: apiMessage.city.name,
                                            sunsetTime: apiMessage.city.sunset)
        self.apiMessage = apiMessage
        if spinnerView.isAnimating {
            spinnerView.stopAnimating()
        }
        tableView.reloadData()
    }
}

extension CommonForecastTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        forecastModel.updateForecast(with: manager.location?.coordinate)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(with: error)
    }
}

extension CommonForecastTableViewController: UIGestureRecognizerDelegate {
    @objc func navigationItemTupped(param: UITapGestureRecognizer) {
        let cityNameAlert = UIAlertController(title: nil, message: "Enter city name", preferredStyle: .alert)
        let cityNameAlertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cityNameAlert.addTextField {
            [weak self] (textFiled) in
            textFiled.delegate = self
            textFiled.placeholder = "City"
            textFiled.restorationIdentifier = "CityNameTextFiled"
        }
        cityNameAlert.addAction(cityNameAlertCancelAction)
        present(cityNameAlert, animated: true, completion: nil)
    }
}

extension CommonForecastTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.restorationIdentifier == "CityNameTextFiled" else {
            textField.resignFirstResponder()
            return true
        }
        guard let cityName = textField.text,
            cityName != "" else {
            return false
        }
        resignFirstResponder()
        self.forecastModel.updateForecast(with: cityName)
        return true
    }
}

