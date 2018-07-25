//
//  ViewController.swift
//  iWeather
//
//  Created by Mac on 7/23/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum TypeWeather: String {
        case rain = "Rain"
        case clouds = "Clouds"
        case clear = "Clear"
    }
    
    fileprivate let cellIdentifier = "CellID"
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var weatherTemperature: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var speedWind: UILabel!
    
    @IBOutlet weak var directionWindImage: UIImageView!
    
    
    private var weatherData: [JSONWeatherData]? {
        didSet {
            populateView()
            //TODO: tableview reload()
        }
    }
   
    
    private var city: JSONCity? {
        didSet {
          populateView()
        }
    }
    
    private var main: JSONMain? {
        didSet {
            populateView()
        }
    }
    
    private var weather: [JSONWeather]? {
        didSet {
            populateView()
            //TODO: tableview reload()
        }
    }
    
    private var wind: JSONWind? {
        didSet {
            populateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func populateView() {
        cityNameLabel.text = city?.name ?? ""
        
        
        guard let _weatherData = weatherData,_weatherData.count
            > 0, let _recentData = _weatherData[0] as? JSONWeatherData else {
            return
        }
        dateLabel.text = weatherData?[0].dt_txt
        weatherTemperature.text = _recentData.main.temp_max.toString()

        humidityLabel.text = _recentData.main.humidity.toString() + "%"
        speedWind.text = Int(_recentData.wind.speed.rounded()).toString() + "m/sec"
        
        guard let _type = weatherData?[0].weather[0].main, _type != "" else {
            return
        }
        displayWeatherImage(type:_type)
        
        guard let _typeWind = weatherData?[0].wind.deg.toString(), _typeWind != "" else {
            return
        }
        displayWindImage(typeWind: _typeWind.toDouble())
        
    }
    
    func displayWeatherImage (type: String){
    // var type = weatherData?[0].weather[0].main
        print("type ++++++++ : \(type)")
        switch (type) {
            case TypeWeather.rain.rawValue:
            weatherImage.image = UIImage(named: "ic_white_day_rain")
            case TypeWeather.clouds.rawValue:
            weatherImage.image = UIImage(named: "ic_white_day_cloudy")
            case TypeWeather.clear.rawValue:
            weatherImage.image = UIImage(named: "ic_white_day_bright")
        default:
            break
        }
    }
    
    func displayWindImage(typeWind: Double){
        print("typeWind ====== : \(typeWind)")
    switch (typeWind) {
    case 0.0...22.0, 338.0...360.0:
    directionWindImage.image = UIImage(named: "icon_wind_n")
   case 23.0...67.0:
   directionWindImage.image = UIImage(named: "icon_wind_ne")
    case 68.0...112.0:
    directionWindImage.image = UIImage(named: "icon_wind_e")
    case 113.0...157.0:
    directionWindImage.image = UIImage(named: "icon_wind_se")
    case 158.0...202.0:
    directionWindImage.image = UIImage(named: "icon_wind_s")
    case 203.0...246.0:
    directionWindImage.image = UIImage(named: "icon_wind_sw")
    case 247.0...292.0:
    directionWindImage.image = UIImage(named: "icon_wind_w")
    case 293.0...237.0:
    directionWindImage.image = UIImage(named: "icon_wind_nw")
    default: break

        }
    }

    private func updateData(term: String = "") {
        APIService.sharedInstance.getWeather(searchText: term, comletion: { [weak self] result in
            
            if let _result = result as? JSONResponse {
                self?.weatherData = _result.list
                self?.city = _result.city
            } else {
                print("to do reset")
            }
        })
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
    
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    }
}


extension ViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
