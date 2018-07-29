//
//  ParseUtil.swift
//  iWeather
//
//  Created by Mac on 7/28/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation
//import SwiftyJSON


final class ParseUtil {
    
    class func parseCities(comletion:((_ cities: [JSONCities])->())) {
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
           
               
                let decoder = JSONDecoder()
                do {
                    let cities: [JSONCities] = try decoder.decode([JSONCities].self, from: data)
                    print("cities: \(cities)")
                    comletion(cities)
                } catch {
                    comletion([])
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}
