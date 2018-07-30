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
    
    class func kelvinToСesiumMaxMin(tempMax: Double?, tempMin:Double?) -> String {
        guard let _tempMax = tempMax, let _tempMin = tempMin else {
            return ""
        }
        let res = Int((_tempMax - 273.15).rounded()).toString() + "°" + "/" + Int((_tempMin - 273.15).rounded()).toString() + "°"
        return res
    }
    
    class func kelvinToСesiumTempMax(temp: JSONMain) -> String {
        let res = Int((temp.temp_max - 273.15).rounded()).toString() + "°"
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
        let total = speeds.reduce(0, +)
        let avgSpeed = total / Double(data.count)
        let currentAvgSpeed = Int(avgSpeed.rounded()).toString() + "m/sec"
            return currentAvgSpeed
    }
    
    class func getAvgMaxTemperature(data: [JSONWeatherData])-> Double? {
        let temp = data.map({$0.main.temp_max})
        let currentTempMax = temp.max()
            return currentTempMax
    }
    
    class func getAvgMinTemperature(data: [JSONWeatherData])-> Double? {
        let temp = data.map({$0.main.temp_min})
        let currentTempMin = temp.min()
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
        let totalWinds = directionWind.reduce(0, +)
        let avgDirectionWind = totalWinds / Double(data.count)
            return avgDirectionWind
    }
    
    class func getAvgImageWeather(data: [JSONWeatherData])-> String {
        let defaultImage = TypeWeather.clear.rawValue
        
        var dic = [String: Int]()
        data.forEach {
            let key = $0.weather[0].main
            let filterArray = data.filter { $0.weather[0].main.contains(key) }
            dic[key] = filterArray.count
        }

        let max = dic.values.max()

        // found all max values
        let allmax = dic.filter { $0.value == max }

        if allmax.count == 1 {
            // if only 1 max result
            return Array(allmax.keys)[0]
        } else {
            // if more: define weights
            let wRain = 3
            let wCloud = 2
            let wClear = 1
            
            var weightDic = [String: Int]()
            for (key,value) in allmax {
                if key == TypeWeather.clear.rawValue {
                    weightDic[key] = value * wClear
                }
                else if key == TypeWeather.clouds.rawValue {
                    weightDic[key] = value * wCloud
                }
                else if key == TypeWeather.rain.rawValue {
                    weightDic[key] = value * wRain
                }
            }

            let maximum = weightDic.max { a, b in a.value < b.value }
            return maximum?.key ?? defaultImage
        }
    }
}
