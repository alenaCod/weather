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
            collectionView.reloadData()
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
            //collectionView.reloadData()
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
        
//        let now = Date()
//        let soon = NSDate(timeIntervalSince1970: 1532746800) as Date
//        let later = NSDate(timeIntervalSince1970: 1532736000) as Date //1532736000
//
//        let range = now...later
//
//        if range.contains(soon) {
//            print("The date is inside the range")
//        } else {
//            print("The date is outside the range")
//        }
//
//        var tmp = [JSONWeatherData]()
//        for w in weatherData {
//            print("data___: ", w.dt_txt)
//            if w.dt_txt.contains("21:00:00") {
//                 let isInToday = DateUtil.dtToDate(dt: w.dt - 1).isInToday
//                 print("isToday___: ", isInToday)
//
//                if(isInToday) {
//                    tmp.append(w)
//                }
//
//            } else {
//                let isInToday = DateUtil.dtToDate(dt: w.dt).isInToday
//                print("isToday___: ", isInToday)
//                if(isInToday) {
//                    tmp.append(w)
//                }
//            }
//        }
//
//        timeSelectedWeatherData = tmp
        
       dayWeatherData = weatherData.filter({$0.dt_txt.contains("03:00:00")})
       print("dayWeatherData: ", dayWeatherData.count)

//        guard let _txtDate = weatherData[0].dt_txt as? String, weatherData.count > 0 else {
//            return
//        }
//
//        print("stringToDate: ", DateUtil.stringToDate(strDate: _txtDate))
//        print("isToday: ", DateUtil.stringToDate(strDate: _txtDate)?.isToday())
        
        print("timeSelectedWeatherData: ", timeSelectedWeatherData.count)
        timeSelectedWeatherData = weatherData.filter({
            (date) in {
                if date.dt_txt.contains("21:00:00") {
                   return DateUtil.dtToDate(dt: date.dt - 1).isInToday
                }
             return DateUtil.dtToDate(dt: date.dt).isInToday
            }()
            })
        print("timeSelectedWeatherData: ", timeSelectedWeatherData.count)
        
       // timeSelectedWeatherData = timeWeatherData.sorted(by: {$0.dt < $1.dt})
        for w in timeSelectedWeatherData {
            print("data___: ", w.dt_txt)
        }
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
        dateLabel.text = DateUtil.dtToDate(dt: _recentData.dt).dateOfWeekAndMonth()
      
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
 
      directionWindImage.image = Util.getWindImage(typeWind: _typeWind.toDouble())
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
        return 72
        
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        cell.configure(forWeather: timeSelectedWeatherData[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSelectedWeatherData.count
    }
}
