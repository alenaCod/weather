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
    
    private init() {}
    
//    func getRecepies(searchText: String, comletion: @escaping (_ result: Any) -> Void) {
//        let url = "https://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=a7310915bce4294c8238dbf07a1d3b63"
//
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
//            .responseJSON { response in
//
//                if let json = response.result.value {
//                     print("json: \(json)")
//                 // let cnt = dic["cnt"] as? [Int: Any]
//                  //  print("cnt   ||  ====   === :\(cnt)")
//                //var _arrJSON = [JSONSettings]()
////                    if let data = json as? [String: Any],
////                        let cnt = data["cnt"] as? [Int: Any] {//
////                        print("cnt222   ||  ====   === :\(cnt)")
//                   // let res = ParserResponseUtils.parseSearchResponse(json).prefix(Constants.recipeLimit)
//                   comletion([])
//                } else {
//                  comletion([])
//              }
//        }
//    }
    
    
    func getWeather(searchText: String, comletion: @escaping (_ result: JSONResponse?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=a7310915bce4294c8238dbf07a1d3b63"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseData { response in
                print("data: \(response)")
                let decoder = JSONDecoder()
                do {
                    guard let data = response.data else {
                        comletion(nil)
                        return
                    }
                    let weather: JSONResponse = try decoder.decode(JSONResponse.self, from: data)
                    print("weather: \(weather)")
                    comletion(weather)
                } catch {
                    comletion(nil)
                }    
        }
    }
//}
} //
