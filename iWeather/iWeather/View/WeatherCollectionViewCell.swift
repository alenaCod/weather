//
//  WeatherCollectionViewCell.swift
//  iWeather
//
//  Created by Mac on 7/26/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var tempLable: UILabel!
    
    func configure(forWeather weather:JSONWeatherData){
        tempLable.text = Util.kelvinToСesiumTempMax(temp: weather.main)
        imageWeather.image = Util.getWeatherImage(type: weather.weather[0].main)
        timeLable.text = weather.dt_txt
        
        print("label:\(tempLable.text)")
    }
}
