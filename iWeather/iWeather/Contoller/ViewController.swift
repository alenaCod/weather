//
//  ViewController.swift
//  iWeather
//
//  Created by Mac on 7/23/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import UIKit


enum TypeWeather: String {
    case rain = "Rain"
    case clouds = "Clouds"
    case clear = "Clear"
}

class ViewController: UIViewController {
    
    static let nibName = "WeatherCell"
    static let cellIdentifier = "WeatherCellID"

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var weatherTemperature: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var speedWind: UILabel!
    
    @IBOutlet weak var directionWindImage: UIImageView!
    
    fileprivate var timeSelectedWeatherData: [JSONWeatherData] = [] {
        didSet {
            // collection reload data
        }
    }

 
    fileprivate var dayWeatherData: [JSONWeatherData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var weatherData: [JSONWeatherData] = [] {
        didSet {
            populateView()
            filterDates()
            collectionView.reloadData()
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

        initTableView()
        updateData()
    }
    
    private func filterDates() {
       print("weatherData: ", weatherData.count)
       dayWeatherData = weatherData.filter({$0.dt_txt.contains("03:00:00")})
       print("dayWeatherData: ", dayWeatherData.count)
    }
    private func initTableView() {
        let nib = UINib(nibName: ViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ViewController.cellIdentifier)
        tableView.backgroundView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    private func populateView() {
        cityNameLabel.text = city?.name ?? ""
        
        guard weatherData.count > 0, let _recentData = weatherData[0] as? JSONWeatherData else {
                return
        }
        dateLabel.text = _recentData.dt_txt
      
//        print("labelText:\(dateLabel.text)")
        
        weatherTemperature.text = Util.kelvinToСesium(temp: _recentData.main)
        humidityLabel.text = Util.percentHumidity(temp: _recentData.main)
        speedWind.text = Util.wind(temp: _recentData.wind)
        
        guard let _type = weatherData[0].weather[0].main as? String, _type != "" else {
            return
        }
        weatherImage.image = Util.getWeatherImage(type:_type)
        //displayWeatherImage(type:_type)
        
        guard let _typeWind = weatherData[0].wind.deg.toString() as? String, _typeWind != "" else {
            return
        }
 
        displayWindImage(typeWind: _typeWind.toDouble())
    }

    func displayWindImage(typeWind: Double) {
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


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier) as! WeatherCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.configureCell(forWeather: dayWeatherData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWeatherData.count
    }
    
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        cell.configure(forWeather: weatherData[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    
    
}
