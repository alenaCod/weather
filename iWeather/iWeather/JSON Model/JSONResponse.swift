//
//  JSONSettings.swift
//  iWeather
//
//  Created by Mac on 7/24/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation

struct JSONResponse: Codable {
    let cnt:Int
    let city: JSONCity
    let list: [JSONWeatherData]
}

struct JSONCity: Codable {
    let name:String 
}

struct JSONWeatherData: Codable {
    let dt:Int
    
}
