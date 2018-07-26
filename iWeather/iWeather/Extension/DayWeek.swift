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
        // or use capitalized(with: locale) if you want
    }
}

extension Date {
    func dayOfWeekWithDayMonth() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E,d MMM"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
}
}
