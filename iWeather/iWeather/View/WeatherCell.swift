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
        
        let avgMaxTemperature = Util.getAvgMaxTemperature(data: weather.value)
        let avgMinTemperature = Util.getAvgMinTemperature(data: weather.value)
      temperatureLabel.text = Util.kelvinToСesiumMaxMin(tempMax: avgMaxTemperature, tempMin: avgMinTemperature)
        
        let avgImageWeather = Util.getAvgImageWeather(data: weather.value)
        cloudImage.image = Util.getWeatherImageBlack(type: avgImageWeather)
    }
    
}
