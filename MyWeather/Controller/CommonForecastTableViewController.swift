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
        let customNavigationItemView = CustomNavigationItemView()
        customNavigationItemView.updateData(sunriseTime: apiMessage.city.sunrise,
                                            cityName: apiMessage.city.name,
                                            sunsetTime: apiMessage.city.sunset)
        customNavigationItemView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        navigationItem.titleView = customNavigationItemView
        self.apiMessage = apiMessage
        spinnerView.stopAnimating()
        tableView.reloadData()
    }
}

extension CommonForecastTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        forecastModel.updateLocation(with: locations.first!)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(with: error)
    }
}

