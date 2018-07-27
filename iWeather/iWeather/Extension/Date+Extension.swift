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
    
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}

extension Date {
    func timeFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self).capitalized
    }
}
extension Date {
    func dateOfWeekAndMonth() -> String {
     let dateFormate = DateFormatter()
     dateFormate.dateFormat = "EE, d MMMM"
     return dateFormate.string(from: self).capitalized
//     let date = NSDate()
//let stringOfDate = dateFormate.stringFromDate(date)
//print(stringOfDate)
}
}

extension Date {
    func time() -> String {
     let dateFormate = DateFormatter()
     dateFormate.dateFormat = "HH:mm"
        
     return dateFormate.string(from: self).capitalized
        //     let date = NSDate()
        //let stringOfDate = dateFormate.stringFromDate(date)
        //print(stringOfDate)
    }
}

extension Date {
    func twelvHours()-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: self)
    }
}

extension Date {
    func twentyFour()-> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: self)
 }
}
