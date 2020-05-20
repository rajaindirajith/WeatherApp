//
//  Utilites.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import Foundation



public class WeatherDateFormatter {
    
    public class func dateFromString(_ format: String = "yyyy-MM-dd HH:mm:ss", str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: str) {
            return date
        }
        print("Date formatter did not work so returing today's date")
        return Date()
    }
    
    public class func stringFromDate(_ format: String = "yyyy-MM-dd", date: Date?) -> String {
        
        if let dateRef = date {
           let formatter = DateFormatter()
           formatter.dateFormat = format
            let dateStr = formatter.string(from: dateRef)
            return dateStr
        }else {
            return ""
        }
    }
    
    
}
