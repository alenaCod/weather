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
        let t = weather.dt_txt.split(separator: " ")[1].split(separator: ":")
        //let t = s[1].split(separator: ":")
        timeLable.text = String(t[0]) + ":" + String(t[1]) //.time()
         print("label:\(timeLable.text)")
        print("label:\(tempLable.text)")
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//
//        let date = dateFormatter.date(from: weather.dt_txt)
//        dateFormatter.dateFormat = "HH:mm"
//
//        let Date24 = dateFormatter.string(from: date!)
//        let d = DateUtil.stringToDate(strDate: weather.dt_txt)?.twelvHours()
//        let dateFormatter = DateFormatter()
//         dateFormatter.dateFormat = "HH:mm"
//        let date = dateFormatter.date(from: d!)
//        timeLable.text = date?.twentyFour()
    }
}
