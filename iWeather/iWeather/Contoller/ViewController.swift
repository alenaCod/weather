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
            buildDailyWeatherData()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCities()
        initTableView()
        
        // load initial city
        updateData(city: JSONCities(name: "Zaporizhzhya", id: 687700))
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

    private func buildDailyWeatherData() {
        var dic = [String: [JSONWeatherData]]()
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

    private func populateView(selected: DailyData) {
        //TODO: find all array accroding to selected date
 
        dateLabel.text = DateUtil.stringToDate(dateString: selected.key)?.dateOfWeekAndMonth()
        speedWind.text = Util.getAvgSpeed(data: selected.value)
        //TODO:..... print avg data
        weatherTemperature.text = Util.getMaxTemperatureInDay(data: selected.value) + "/" + Util.getMinTemperatureInDay(data: selected.value)
        humidityLabel.text = Util.getAvgHumidity(data: selected.value)
        let r = Util.getAvgDirectionWind(data: selected.value)
        directionWindImage.image = Util.getWindImage(typeWind: r)
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

 guard let _type = selected.weather[0].main as? String, _type != "" else {
 return
 }
 weatherImage.image = Util.getWeatherImage(type:_type)
 
 guard let _typeWind = selected.wind.deg.toString() as? String, _typeWind != "" else {
 return
 }
 */
