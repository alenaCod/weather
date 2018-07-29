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
typealias DailyData = (key: String, value: [JSONWeatherData])

class ViewController: UIViewController {

    static let nibName = "WeatherCell"
    static let cellIdentifier = "WeatherCellID"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var weatherTemperature: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCityTap))
            cityNameLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var speedWind: UILabel!
    
    @IBOutlet weak var directionWindImage: UIImageView!
    
    
    // Initial data obtained from server
    fileprivate var weatherData: [JSONWeatherData] = [] {
        didSet {
            filterDates()
            initialSelectedData()
        }
    }
    
    fileprivate var selectedCity: JSONCities? {
        didSet {
            guard let _selectedCity = selectedCity else {
                return
            }
            updateData(city: _selectedCity)
        }
    }
    
    fileprivate var cities: [JSONCities] = [JSONCities]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    fileprivate var selectedWeatherData: DailyData? {
        didSet {
            guard let _selected = selectedWeatherData else {
                return
            }
            populateView(selected: _selected)
            collectionView.reloadData()
        }
    }
    
    fileprivate var dailyWeatherData = [DailyData]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var city: JSONCity? {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCities()
        initTableView()
        
        // load initial city
        updateData(city: JSONCities(name: "Moscov", id: 524901))
    }
    
    private func loadCities() {
        ParseUtil.parseCities(comletion: { [weak self] cities in
            self?.cities = cities
        })
    }
    
    private func updateData(city: JSONCities) {
        cityNameLabel.text = city.name
        
        APIService.sharedInstance.getWeather(idCity: city.id, comletion: { [weak self] result in
            
            if let _result = result as? JSONResponse {
                self?.weatherData = _result.list
                self?.city = _result.city
            } else {
                print("to do reset")
            }
        })
    }
    
    private func initTableView() {
        let nib = UINib(nibName: ViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ViewController.cellIdentifier)
        tableView.backgroundView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func filterDates() {
        var dic = [String: [JSONWeatherData]]() //[String: [JSONWeatherData]]() // Your required result
        weatherData.forEach {
            let dateKey = DateUtil.dtToDate(dt: $0.dt).day()
            let filterArray = weatherData.filter { $0.dt_txt.contains(dateKey) }
            dic[dateKey] = filterArray
        }
        print("dic: ", dic.count)
        let sorted = dic.sorted(by: { $0.0 < $1.0})
 
        for (key, value) in sorted {
            print("=== ")
            print("key: ", key)

            for v in value {
                print("value: ", v.dt_txt)
            }
           
        }
        dailyWeatherData = sorted
    }
    
    func initialSelectedData() {
        guard dailyWeatherData.count > 0  else {
            return
        }
        selectedWeatherData = dailyWeatherData[0]
    }
    
    private func getHourlyData() {
        // enter date of all day
//        guard let _selectedWeatherData = selectedWeatherData else {
//            return
//        }
        
//        guard let arr = _selectedWeatherData.dt_txt.split(separator: " ") as? [String.SubSequence], arr.count > 0 else {
//            return
//        }
        //hourlyWeatherData = selectedWeatherData. //weatherData.filter({$0.dt_txt.contains(String(arr[0]))})
    }

    private func populateView(selected: DailyData) {
        //TODO: find all array accroding to selected date
 
        dateLabel.text = DateUtil.stringToDate(dateString: selected.key)?.dateOfWeekAndMonth()

        speedWind.text = Util.getAvgSpeed(data: selected.value).toString() + "m/sec"
        //TODO:..... print avg data
    }
    
    @objc func handleCityTap(sender: UITapGestureRecognizer? = nil) {
        displayPicker(isVisible: true)
    }
    
    fileprivate func displayPicker(isVisible: Bool) {
        self.pickerView.isHidden = !isVisible
        
        //        UIView.animate(withDuration: 1.0, delay: 1.2, options: .curveEaseOut, animations: {
        //
        //            if isVisible {
        //                var topFrame = self.view.frame
        //                topFrame.origin.y -= self.pickerView.frame.size.height
        //                self.pickerView.frame = topFrame
        //            }
        //
        //        }, completion: { finished in
        //            self.pickerView.isHidden = !isVisible
        //        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier) as! WeatherCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        cell.configureCell(forWeather: dailyWeatherData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeatherData.count
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedWeatherData = dailyWeatherData[indexPath.row]
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
        if let hourlyWeatherData = selectedWeatherData?.value[indexPath.row] {
            cell.configure(forWeather: hourlyWeatherData)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedWeatherData?.value.count ?? 0
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cities[row]
        pickerView.isHidden = true
    }
}

/*
 private func populateView(selected: JSONWeatherData) {
 //TODO: find all array accroding to selected date
 selectedWeatherData = selected
 
 dateLabel.text = DateUtil.dtToDate(dt: selected.dt).dateOfWeekAndMonth()
 
 //TODO: ....
 //  weatherTemperature.text = Util.kelvinToСesium(temp: selected.main)
 // humidityLabel.text = Util.percentHumidity(temp: selected.main)
 // averege speed
 
 speedWind.text = Util.getAvgSpeed(data: hourlyWeatherData).toString() + "m/sec"
 
 //all  max temp in day
 let temp = hourlyWeatherData.map({$0.main.temp_max})
 print("temp :", temp) // temp.max()
 //curret max temp
 let currentTempMax =  temp.max()
 let r = Util.kelvinToСesiumTemp(temp: (currentTempMax!))
 print("r :", r)
 // all min temp in day
 let tMin = hourlyWeatherData.map({$0.main.temp_min})
 print("temp :", temp) // temp.max()
 // current min temp
 let currentTempMin =  tMin.min()
 
 weatherTemperature.text = Util.kelvinToСesiumMaxMin(tempMax: currentTempMax!, tempMin: currentTempMin!)
 // all humidityes in day
 
 let humiditys = hourlyWeatherData.map({$0.main.humidity})
 print("hum :", humiditys)
 let totalHumiditys = humiditys.reduce(0, +)
 print("totalH :", totalHumiditys)
 let avgHumidity = totalHumiditys / (hourlyWeatherData.count)
 print("avgHumidity :",avgHumidity)
 humidityLabel.text = avgHumidity.toString() + "%"
 
 guard let _type = selected.weather[0].main as? String, _type != "" else {
 return
 }
 weatherImage.image = Util.getWeatherImage(type:_type)
 
 guard let _typeWind = selected.wind.deg.toString() as? String, _typeWind != "" else {
 return
 }
 
 directionWindImage.image = Util.getWindImage(typeWind: _typeWind.toDouble())
 }
 */

/*
 var dic = [String:[JSONWeatherData]]() // Your required result
 weatherData.forEach {
 if let arr = $0.dt_txt.split(separator: " ") as? [String.SubSequence], arr.count > 0 {
 let dateKey = String(arr[0])
 let filterArray = weatherData.filter { $0.dt_txt.contains(dateKey) }
 dic[dateKey] = filterArray
 }
 }
 print("dic: ", dic.count)
 let sorted = dic.sorted(by: { $0.0 < $1.0})
 for (key, value) in sorted {
 print("=== ")
 print("key: ", key)
 
 for v in value {
 print("value: ", v.dt_txt)
 }
 }
 */
