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
    private var apiMessage: ApiMessage?
    private var location: CLLocation?
    private var customNavigationItemView: CustomNavigationItemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastModel.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
        tableView.register(UINib(nibName: "CommonForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "CommonForecastTableViewCell")
        tableView.rowHeight = 60
        
        customNavigationItemView = CustomNavigationItemView()
        customNavigationItemView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
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
    
    func configureErrorAlert(with error: Error) -> UIAlertController{
        let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let reloadErrorAlertAction = UIAlertAction(title: "Reload", style: .default, handler: {
            [weak self] (_) in
            self?.locationManager.requestLocation()
        })
        errorAlert.addAction(reloadErrorAlertAction)
        return errorAlert
    }
    
    func updateForecast(with apiMessage: ApiMessage?, error: Error?) {
        guard error == nil else {
            present(configureErrorAlert(with: error!), animated: true, completion: nil)
            return
        }
        guard let apiMessage = apiMessage else {
            present(configureErrorAlert(with: ApiModelErrors.WrongApiMessage), animated: true, completion: nil)
            return
        }
        (navigationItem.titleView as! CustomNavigationItemView).updateData(sunriseTime: apiMessage.city.sunrise,
                                            cityName: apiMessage.city.name,
                                            sunsetTime: apiMessage.city.sunset)
        self.apiMessage = apiMessage
        tableView.reloadData()
    }
}

extension CommonForecastTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        forecastModel.updateForecast(with: manager.location?.coordinate)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        present(configureErrorAlert(with: error), animated: true, completion: nil)
    }
}

extension CommonForecastTableViewController: UIGestureRecognizerDelegate {
    func configureCityNameAlert() -> UIAlertController {
        let cityNameAlert = UIAlertController(title: nil, message: "Enter city name", preferredStyle: .alert)
        let cityNameAlertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cityNameAlertReloadAction = UIAlertAction(title: "Reload", style: .default) {
            [weak self] (_) in
            guard let cityName = cityNameAlert.textFields?.first?.text, cityName != "" else {
                return
            }
            (self?.navigationItem.titleView as! CustomNavigationItemView).startUpdating()
            self?.forecastModel.updateForecast(with: cityName)
        }
        cityNameAlert.addTextField(configurationHandler: nil)
        cityNameAlert.addAction(cityNameAlertCancelAction)
        cityNameAlert.addAction(cityNameAlertReloadAction)
        return cityNameAlert
    }
    
    @objc func navigationItemTupped(param: UITapGestureRecognizer) {
        present(configureCityNameAlert(), animated: true, completion: nil)
    }
}

