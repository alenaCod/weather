//
//  DayWeek.swift
//  iWeather
//
//  Created by Mac on 7/26/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func dateOfWeekAndMonth() -> String {
        let dateFormate = DateFormatter()
        dateFormate.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        dateFormate.dateFormat = "EE, d MMMM"
        return dateFormate.string(from: self).capitalized
    }
    
    func day() -> String {
        let dateFormate = DateFormatter()
        dateFormate.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        dateFormate.dateFormat = "yyyy-MM-dd" //2018-08-01
        return dateFormate.string(from: self).capitalized
    }
}


