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
    
    class func kelvinToСesiumMaxMin(tempMax: Double, tempMin:Double) -> String {
        let res = Int((tempMax - 273.15).rounded()).toString() + "°" + "/" + Int((tempMin - 273.15).rounded()).toString() + "°"
        return res
    }
    
    class func kelvinToСesiumTempMax(temp: JSONMain) -> String {
        let res = Int((temp.temp_max - 273.15).rounded()).toString() + "°"
        return res
    }
    class func kelvinToСesiumTemp(temp: Double) -> String {
        let res = Int((temp  -  273.15).rounded()).toString() + "°"
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
        case 0.0...22.9, 338.0...360.9:
            return UIImage(named: "icon_wind_n")
        case 23.0...67.9:
            return UIImage(named: "icon_wind_ne")
        case 68.0...112.9:
            return UIImage(named: "icon_wind_e")
        case 113.0...157.9:
            return UIImage(named: "icon_wind_se")
        case 158.0...202.9:
            return UIImage(named: "icon_wind_s")
        case 203.0...246.9:
            return UIImage(named: "icon_wind_sw")
        case 247.0...292.9:
            return UIImage(named: "icon_wind_w")
        case 293.0...337.9:
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
    
    //MARK: avg calculation
    
    class func getAvgSpeed(data: [JSONWeatherData]) -> String {
        let speeds = data.map({$0.wind.speed})
        print("speeds :", speeds)
        let total = speeds.reduce(0, +)
        print("total :", total)
        let avgSpeed = total / Double(data.count)
        print("avgSpeed :", avgSpeed)
        let currentAvgSpeed = Int(avgSpeed.rounded()).toString() + "m/sec"
            return currentAvgSpeed
    }
    
    class func getMaxTemperatureInDay(data: [JSONWeatherData])-> String {
        let temp = data.map({$0.main.temp_max})
        let currentTempMax = Int((temp.max()! - 273.15).rounded()).toString() + "°"
            return currentTempMax
    }
    
    class func getMinTemperatureInDay(data: [JSONWeatherData])-> String {
        let temp = data.map({$0.main.temp_min})
        let currentTempMin = Int((temp.min()! - 273.15).rounded()).toString() + "°"
            return currentTempMin
    }
    
    class func getAvgHumidity(data: [JSONWeatherData])-> String {
        let humiditys = data.map({$0.main.humidity})
        let totalHumiditys = humiditys.reduce(0, +)
        let avgHumidity = totalHumiditys / data.count
         return avgHumidity.toString() + "%"
    }
    
    class func getAvgDirectionWind(data: [JSONWeatherData])-> Double {
        let directionWind = data.map({$0.wind.deg})
       // print("hum :", humiditys)
        let totalWinds = directionWind.reduce(0, +)
        //print("totalH :", totalHumiditys)
        let avgDirectionWind = totalWinds / Double(data.count)
        print("avgDirection :",avgDirectionWind)
        return avgDirectionWind
    }
}
