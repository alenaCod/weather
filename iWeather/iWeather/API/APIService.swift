//
//  APIService.swift
//  iWeather
//
//  Created by Mac on 7/24/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    static let sharedInstance = APIService()
    
    private let appID = "a7310915bce4294c8238dbf07a1d3b63"
    
    private init() {}
    
    func getWeather(idCity: Int, comletion: @escaping (_ result: JSONResponse?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?id=\(idCity.toString())&APPID=\(appID)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseData { response in
                
                let decoder = JSONDecoder()
                do {
                    guard let data = response.data else {
                        comletion(nil)
                        return
                    }
                    let weather: JSONResponse = try decoder.decode(JSONResponse.self, from: data)
                    comletion(weather)
                } catch {
                    comletion(nil)
                }    
        }
    }
} 
