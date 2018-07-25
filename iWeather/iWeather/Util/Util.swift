//
//  Util.swift
//  iWeather
//
//  Created by Mac on 7/25/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation


class Util {
    class func calvineToCelsious(temp: JSONMain) -> String {
        let res = Int((temp.temp_max - 273.15).rounded()).toString() + "°" + "/" + Int((temp.temp_min - 273.15).rounded()).toString() + "°"
        return res
    }
    
    class func percentHumidity (temp:JSONMain) -> String {
      let res = temp.humidity.toString() + "%"
        return res
    }
    
    class func wind (temp:JSONWind) -> String {
       let res =  Int(temp.speed.rounded()).toString() + "m/sec"
        //let res = temp.humidity.toString() + "%"
        return res
    }
}
