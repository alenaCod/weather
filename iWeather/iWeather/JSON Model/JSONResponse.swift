//
//  JSONSettings.swift
//  iWeather
//
//  Created by Mac on 7/24/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation

struct JSONResponse: Codable {
    let city: JSONCity
    let list: [JSONWeatherData]
}

struct JSONCity: Codable {
    let name:String 
}

struct JSONWeatherData: Codable {
    let dt_txt: String
    let dt: Int
    let main: JSONMain
    let weather: [JSONWeather]
    let wind: JSONWind
}

struct JSONMain: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}

struct JSONWeather: Codable {
    let main: String
    let icon: String
}

struct JSONWind: Codable {
   let speed: Double
    let deg : Double
}
