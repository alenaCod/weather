//
//  ParseUtil.swift
//  iWeather
//
//  Created by Mac on 7/28/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation

final class ParseUtil {
    
    class func parseLocations(comletion:((_ locations: [JSONLocation])->())) {
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)

                let decoder = JSONDecoder()
                do {
                    let locations: [JSONLocation] = try decoder.decode([JSONLocation].self, from: data)
                    //print("locations: \(locations)")
                    comletion(locations)
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
