//
//  ViewController.swift
//  iWeather
//
//  Created by Mac on 7/23/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    private var locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    
    // Initial data obtained from server
    fileprivate var weatherData: [JSONWeatherData] = [] {
        didSet {
            buildDailyWeatherData()
            initialSelectedData()
        }
    }
    
    fileprivate var selectedLocation: JSONLocation? {
        didSet {
            guard let _selectedLocation = selectedLocation else {
                return
            }
            updateData(location: _selectedLocation)
        }
    }
    
    fileprivate var locations = [JSONLocation]()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.locationChanged),
            name: NSNotification.Name(rawValue: "LocationChangeNotification"),
            object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotification()
        startLocationUpdates()
        
        loadLocations()
        initTableView()
        
        // load initial city
        //updateData(location: JSONLocation(name: "Zaporizhzhya", id: 687700))
    }

    private func loadLocations() {
        ParseUtil.parseLocations(comletion: { [weak self] locations in
            self?.locations = locations
        })
    }
    
   
    
    private func updateData(location: JSONLocation) {
        cityNameLabel.text = location.name
        
        APIService.sharedInstance.getWeather(idCity: location.id, comletion: { [weak self] result in
            
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
//        
//        for (key, value) in sorted {
//            print("=== ")
//            print("key: ", key)
//            
//            for v in value {
//                print("value: ", v.dt_txt)
//            }
//        }
        dailyWeatherData = sorted
    }
    
    func initialSelectedData() {
        guard dailyWeatherData.count > 0  else {
            return
        }
        selectedWeatherData = dailyWeatherData[0]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLocations"{
            if let locationsViewController = segue.destination as? LocationsViewController{
                locationsViewController.parsedLocations = locations
            }
        }
    }
    
    private func populateView(selected: DailyData) {
        //TODO: find all array accroding to selected date
        
        dateLabel.text = DateUtil.stringToDate(dateString: selected.key)?.dateOfWeekAndMonth()
        speedWind.text = Util.getAvgSpeed(data: selected.value)
        
        let avgMaxTemperature = Util.getAvgMaxTemperature(data: selected.value)
        let avgMinTemperature = Util.getAvgMinTemperature(data: selected.value)
        weatherTemperature.text = Util.kelvinToСesiumMaxMin(tempMax: avgMaxTemperature, tempMin: avgMinTemperature)
        
        humidityLabel.text = Util.getAvgHumidity(data: selected.value)
        
        let avgDirectionWind = Util.getAvgDirectionWind(data: selected.value)
        directionWindImage.image = Util.getWindImage(typeWind: avgDirectionWind)
        
        let avgImageWeather =  Util.getAvgImageWeather(data: selected.value)
        weatherImage.image = Util.getWeatherImage(type: avgImageWeather)
    }
    
    @objc func handleCityTap(sender: UITapGestureRecognizer? = nil) {
        displayLocationsViewController()
    }
    
    func displayLocationsViewController() {
        guard locations.count > 0 else {
            return
        }
        self.performSegue(withIdentifier: "segueLocations", sender: self)
    }

    @objc func locationChanged(notification: NSNotification){
        print("notification: ", notification)
        guard let _location = notification.userInfo?["location"] as? JSONLocation else {
            return
        }
        selectedLocation = _location
    }
    
    func startLocationUpdates() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = 5000.0
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .fitness
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.startUpdatingLocation()
    }
    
    
    func fetchCityAndCountry(location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func searchForAutoDefinedLocation(cityName: String) {
        guard locations.count > 0 else {
            return
        }
        let location = locations.filter({ $0.name.lowercased().contains(cityName.lowercased())})
        print("result: ", location)
        
        guard let _last = location.last else {
            return
        }
        updateData(location: _last)
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

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Perform location-based activity
        
        //let newLocation = locations.last
        
        guard let location = locations.last as? CLLocation else {
            return
        }

        fetchCityAndCountry(location: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            print("latitude: ", location.coordinate.latitude)
            print("longitude: ", location.coordinate.longitude)
            
            self.searchForAutoDefinedLocation(cityName: city)
            //TODO: serch in parsed array
        }

    }
}

