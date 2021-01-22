//
//  ForecastController.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/21/21.
//

import UIKit

class ForecastController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loader:    UIActivityIndicatorView!
    
    private var weatherNumInFirstDay = 0
    private let service              = WeatherService()
    
    private var weather: ForecastWeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.register(UINib(nibName: "ForecastCell",        bundle: nil), forCellReuseIdentifier:             "ForecastCell")
        tableView.register(UINib(nibName: "WeekdayHeaderView",   bundle: nil), forHeaderFooterViewReuseIdentifier: "WeekdayHeaderView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    @IBAction func refresh() {
        tableView.isHidden = true
        guard let city = CurrentDayController.currentWeatherCity() else { return }
        
        loader.startAnimating()
        service.loadForecastWeatherResponce(city: city) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let weatherResponse):
                        self.tableView.isHidden = false
                        self.weather = weatherResponse
                        self.tableView.reloadData()
                        
                    case .failure( _):
                        break
                }
                self.loader.stopAnimating()
            }
        }
    }
    
    @IBAction func openSettings() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let settingsController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsController") as? SettingsController {
            settingsController.delegate = self
            settingsController.modalPresentationStyle = .overFullScreen
            present(settingsController, animated: true, completion: nil)
        }
    }
    
}

extension ForecastController: SettingsDelegate {
    
    func settingsChanged(_ sender: SettingsController) {
        tableView.reloadData()
    }
    
}

extension ForecastController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let weatherList = weather?.list else { return 0 }
        
        let firstDate = weatherList.first!.date
        let lastDate  = weatherList.last!.date
        
        let component = Calendar.current.dateComponents([Calendar.Component.day], from: firstDate, to: lastDate)
        return component.day! + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherList = weather?.list else { return 0 }
        
        if section == 0 {
            var count = 0
            let firstDay = weatherList.first!.date
            for weather in weatherList {
                if firstDay == weather.date {
                    count += 1
                }
            }
            
            weatherNumInFirstDay = count
            return count
        } else if section == tableView.numberOfSections - 1 {
            var count = 0
            let lastDay = weatherList.last!.date
            for weather in weatherList {
                if lastDay == weather.date {
                    count += 1
                }
            }
            return count
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        
        var weatherIndex = indexPath.row
        if indexPath.section > 0 {
            weatherIndex += weatherNumInFirstDay + 8 * (indexPath.section - 1)
        }
        
        if let forecastCell = cell as? ForecastCell, let weatherList = weather?.list[weatherIndex] {
            forecastCell.timeLabel.text = weatherList.time
            forecastCell.weatherDescriptionLabel.text = weatherList.weather[0].description
            forecastCell.weatherImageView.downloadImage(urlString: weatherList.weather[0].iconUrlStr)
            forecastCell.temperatureLabel.text = Common.getTemperatureString(degree: weatherList.main.temperature)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeekdayHeaderView")
        header?.backgroundView = UIView()
        header?.backgroundView?.backgroundColor = Constants.backgroundColor
        
        if let weekdayHeaderView = header as? WeekdayHeaderView, let weatherList = weather?.list {
            let weatherIndex = min(8 * section + weatherNumInFirstDay - 1, weatherList.count - 1)
            let weekday      = Calendar.current.component(.weekday, from: weatherList[weatherIndex].date)
            
            weekdayHeaderView.weekdayLabel.text = Constants.weekdays[weekday - 1]
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
