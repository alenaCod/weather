//
//  String + Int + Double.swift
//  iWeather
//
//  Created by Mac on 7/24/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation

extension String {
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}

extension String {
    
    func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
}
