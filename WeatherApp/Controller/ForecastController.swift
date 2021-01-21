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
    private let kelvinOffset         = 273.15
    private let service              = WeatherService()
    private let dateFormatter        = DateFormatter()
    private var weather: ForecastWeatherResponse?
    
    private let weekdays: [String] = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy'-'mm'-'dd'"
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.register(UINib(nibName: "ForecastCell",        bundle: nil), forCellReuseIdentifier:             "ForecastCell")
        tableView.register(UINib(nibName: "WeekdayHeaderView",   bundle: nil), forHeaderFooterViewReuseIdentifier: "WeekdayHeaderView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    @IBAction func refresh() {
        guard let city = CurrentDayController.currentWeatherCity() else { return }
        
        tableView.isHidden = true
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
    
}

extension ForecastController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let weatherList = weather?.list else { return 0 }
        
        let firstFullDate = weatherList.first!.dt_txt.split(separator: " ")
        let firstDate = dateFormatter.date(from: String(firstFullDate[0]))
        
        let lastFullDate = weatherList.last!.dt_txt.split(separator: " ")
        let lastDate = dateFormatter.date(from: String(lastFullDate[0]))
        
        let component = Calendar.current.dateComponents([Calendar.Component.day], from: firstDate!, to: lastDate!)
        return component.day! + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherList = weather?.list else { return 0 }
        
        if section == 0 {
            var count = 0
            let firstDay = weatherList.first!.dt_txt.split(separator: " ")[0]
            for weather in weatherList {
                if firstDay == weather.dt_txt.split(separator: " ")[0] {
                    count += 1
                }
            }
            
            weatherNumInFirstDay = count
            return count
        } else if section == tableView.numberOfSections - 1 {
            var count = 0
            let lastDay = weatherList.last!.dt_txt.split(separator: " ")[0]
            for weather in weatherList {
                if lastDay == weather.dt_txt.split(separator: " ")[0] {
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
        
        guard let weather = weather?.list[weatherIndex] else { return cell }
        
        if let forecastCell = cell as? ForecastCell {
            let fullDate = weather.dt_txt.split(separator: " ")
            let time = String(fullDate[1])
            let timeWithoutSecond = time[..<time.lastIndex(of: ":")!]
            
            forecastCell.timeLabel.text = String(timeWithoutSecond)
            forecastCell.weatherDescriptionLabel.text = weather.weather[0].description
            forecastCell.weatherImageView.downloadImage(urlString: "https://openweathermap.org/img/w/\(weather.weather[0].icon).png")
            forecastCell.temperatureLabel.text = String(format: "%.1f°C", weather.main.temp - kelvinOffset)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeekdayHeaderView")
        header?.backgroundView = UIView()
        header?.backgroundView?.backgroundColor = UIColor(named: "bg-gradient-end")!
        
        guard let weatherList = weather?.list else { return header }
        
        if let weekdayHeaderView = header as? WeekdayHeaderView {
            let weatherIndex = min(8 * section + weatherNumInFirstDay - 1, weatherList.count - 1)
            let fullDateStr  = weatherList[weatherIndex].dt_txt.split(separator: " ")
            let date         = dateFormatter.date(from: String(fullDateStr[0]))!
            let weekday      = Calendar.current.component(.weekday, from: date)
            
            weekdayHeaderView.weekdayLabel.text = weekdays[weekday - 1]
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
