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
    
    fileprivate var selectedWeatherData: JSONWeatherData? {
        didSet {
            getTimesbySelectedDate()
        }
    }
    
    fileprivate var timeWeatherData: [JSONWeatherData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    fileprivate var dayWeatherData: [JSONWeatherData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var weatherData: [JSONWeatherData] = [] {
        didSet {
            guard weatherData.count > 0, let _recentData = weatherData[0] as? JSONWeatherData else {
                return
            }
            
            populateView(selected: _recentData)
            filterDates()
            //collectionView.reloadData()
        }
    }

    private var city: JSONCity? {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseUtil.parseCities(comletion: { [weak self] cities in
            print("json cties:", cities)
            self?.cities = cities
        })
        initTableView()
 
        // load initial city
        updateData(city: JSONCities(name: "Moscov", id: 524901))
    }
    
    private func filterDates() {
        
        dayWeatherData = weatherData.filter({$0.dt_txt.contains("03:00:00")})
        
        //let d = weatherData.filter({($0.main.temp_max).toString().contains("03:00:00")})
        // print("d:", d)
    }
    
    private func getTimesbySelectedDate() {
        // enter date of all day
        guard let _selectedWeatherData = selectedWeatherData else {
            return
        }
        guard let arr = _selectedWeatherData.dt_txt.split(separator: " ") as? [String.SubSequence], arr.count > 0 else {
            return
        }
        timeWeatherData = weatherData.filter({$0.dt_txt.contains(String(arr[0]))})
    }
    
    private func initTableView() {
        let nib = UINib(nibName: ViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ViewController.cellIdentifier)
        tableView.backgroundView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func populateView(selected: JSONWeatherData) {
        //TODO: find all array accroding to selected date
        selectedWeatherData = selected
        
        dateLabel.text = DateUtil.dtToDate(dt: selected.dt).dateOfWeekAndMonth()
        
        //TODO: ....
        //  weatherTemperature.text = Util.kelvinToСesium(temp: selected.main)
        // humidityLabel.text = Util.percentHumidity(temp: selected.main)
        // averege speed
        let speeds = timeWeatherData.map({$0.wind.speed})
        print("speeds :", speeds)
        let total = speeds.reduce(0, +)
        print("total :", total)
        let avgSpeed = total / Double(timeWeatherData.count)
        print("avgSpeed :", avgSpeed)
        speedWind.text = Int(avgSpeed.rounded()).toString() + "m/sec"//Util.wind(temp: avgSpeed)//selected.wind)
        
        //  speedWind.text = Util.wind(temp: selected.wind.)
        print("speedsWind:",speedWind)
        
        //all  max temp in day
        let temp = timeWeatherData.map({$0.main.temp_max})
        print("temp :", temp) // temp.max()
        //curret max temp
        let currentTempMax =  temp.max()
        let r = Util.kelvinToСesiumTemp(temp: (currentTempMax!))
        print("r :", r)
        // all min temp in day
        let tMin = timeWeatherData.map({$0.main.temp_min})
        print("temp :", temp) // temp.max()
        // current min temp
        let currentTempMin =  tMin.min()
        
        weatherTemperature.text = Util.kelvinToСesiumMaxMin(tempMax: currentTempMax!, tempMin: currentTempMin!)
        // all humidityes in day
        
        let humiditys = timeWeatherData.map({$0.main.humidity})
        print("hum :", humiditys)
        let totalHumiditys = humiditys.reduce(0, +)
        print("totalH :", totalHumiditys)
        let avgHumidity = totalHumiditys / (timeWeatherData.count)
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
      
        populateView(selected: dayWeatherData[indexPath.row])
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
        cell.configure(forWeather: timeWeatherData[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeWeatherData.count
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
