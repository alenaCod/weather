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
        // Initialization code
    }

   func configureCell(forWeather weather : JSONWeatherData){
    dayWeek.text = weather.dt_txt + " - " + (DateUtil.getDayOfWeek(weather.dt_txt)?.toString())!
    dayWeek.text = DateUtil.stringToDate(strDate: weather.dt_txt)?.dayOfWeek()
    temperatureLabel.text = Util.kelvinToСesium(temp: weather.main)
    cloudImage.image = Util.getWeatherImage(type: weather.weather[0].main)
   // print("image ===:\(Util.getWeatherImage(type: weather.weather[0].main))")
    
    }
    
}
