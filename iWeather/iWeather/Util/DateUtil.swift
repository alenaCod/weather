//
//  DateUtil.swift
//  iWeather
//
//  Created by Mac on 7/26/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation

class DateUtil {
    class func dtToDate(dt: Int) -> Date {
        return NSDate(timeIntervalSince1970: dt.toDouble()) as Date
    }
    
    class func stringToDate(dateString: String) -> Date? {
        var dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString) ?? nil
    }
}

