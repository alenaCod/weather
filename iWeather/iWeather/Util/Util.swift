//
//  Util.swift
//  iWeather
//
//  Created by Mac on 7/25/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation
import UIKit

class Util {
    class func kelvinToСesium(temp: JSONMain) -> String {
        let res = Int((temp.temp_max - 273.15).rounded()).toString() + "°" + "/" + Int((temp.temp_min - 273.15).rounded()).toString() + "°"
        return res
    }
    class func kelvinToСesiumTempMax(temp: JSONMain) -> String {
        let res = Int((temp.temp_max - 273.15).rounded()).toString() + "°"
        return res
    }
    
    class func percentHumidity (temp:JSONMain) -> String {
      let res = temp.humidity.toString() + "%"
        return res
    }
    
    class func wind (temp:JSONWind) -> String {
       let res = Int(temp.speed.rounded()).toString() + "m/sec"
        return res
    }
    
    class func getWeatherImage(type: String) -> UIImage? {
        switch (type) {
            case TypeWeather.rain.rawValue:
                return UIImage(named: "ic_white_day_rain")
            case TypeWeather.clouds.rawValue:
                return  UIImage(named: "ic_white_day_cloudy")
            case TypeWeather.clear.rawValue:
                return UIImage(named: "ic_white_day_bright")
            default:
                return nil
        }
    }
    
  class  func getWindImage(typeWind: Double) -> UIImage? {
        switch (typeWind) {
        case 0.0...22.0, 338.0...360.0:
            return UIImage(named: "icon_wind_n")
        case 23.0...67.0:
            return UIImage(named: "icon_wind_ne")
        case 68.0...112.0:
            return UIImage(named: "icon_wind_e")
        case 113.0...157.0:
            return UIImage(named: "icon_wind_se")
        case 158.0...202.0:
            return UIImage(named: "icon_wind_s")
        case 203.0...246.0:
            return UIImage(named: "icon_wind_sw")
        case 247.0...292.0:
            return UIImage(named: "icon_wind_w")
        case 293.0...237.0:
            return UIImage(named: "icon_wind_nw")
        default:
            return nil
            
        }
    }
    
    class func getWeatherImageBlack(type: String) -> UIImage? {
        switch (type) {
        case TypeWeather.rain.rawValue:
            return UIImage(named: "ic_white_day_rain_black")
        case TypeWeather.clouds.rawValue:
            return  UIImage(named: "ic_white_day_cloudy_black")
        case TypeWeather.clear.rawValue:
            return UIImage(named: "ic_white_day_bright_black")
        default:
            return nil
        }
    }
}
