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
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).capitalized
    }
    
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func dateOfWeekAndMonth() -> String {
     let dateFormate = DateFormatter()
     dateFormate.dateFormat = "EE, d MMMM"
     return dateFormate.string(from: self).capitalized
    }

    func time() -> String {
     let dateFormate = DateFormatter()
     dateFormate.dateFormat = "HH:mm"
     return dateFormate.string(from: self).capitalized
    }
}


