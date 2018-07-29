//
//  WeatherCell.swift
//  iWeather
//
//  Created by Mac on 7/26/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import UIKit
import Foundation

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var dayWeek: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(forWeather weather: DailyData){
        dayWeek.text =  DateUtil.stringToDate(dateString: weather.key)?.dayOfWeek()
        //DateUtil.dtToDate(dt: weather.dt).dayOfWeek()
        //print("cell dt:", weather.dt)
        
      temperatureLabel.text = Util.getMaxTemperatureInDay(data: weather.value) + "/" + Util.getMinTemperatureInDay(data: weather.value)
       // cloudImage.image = Util.getWeatherImageBlack(type: weather.weather[0].main)
    }
    
}
