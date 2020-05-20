//
//  WeatherModel.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import Foundation

class WindModel: Decodable {
    
    var speed:Double?
    var deg:Double?
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }

    public init(){

    }
     
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let speed = try container.decodeIfPresent(Double.self, forKey: .speed) {
          self.speed = speed
        }
        if let deg = try container.decodeIfPresent(Double.self, forKey: .deg) {
          self.deg = deg
        }
    }
    
}

class WeatherDetail: Decodable {
    
    var wId:Int?
    var main:String = ""
    var desc:String = ""
    var icon:String = ""
    
    enum CodingKeys: String, CodingKey {
        case wId = "id"
        case main = "main"
        case desc = "description"
        case icon = "icon"
    }

    public init(){
      
    }
       
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let wId = try container.decodeIfPresent(Int.self, forKey: .wId) {
            self.wId = wId
        }
        if let main = try container.decodeIfPresent(String.self, forKey: .main) {
            self.main = main
        }
        if let desc = try container.decodeIfPresent(String.self, forKey: .desc) {
            self.desc = desc
        }

        if let icon = try container.decodeIfPresent(String.self, forKey: .icon) {
            self.icon = icon
        }
    }
        
}

class TemperatureModel: Decodable {

    var current:Double = 0.0
    var max:Double = 0.0
    var min:Double = 0.0

    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case max = "temp_max"
        case min = "temp_min"
    }

    public init(){

    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let current = try container.decodeIfPresent(Double.self, forKey: .current) {
            self.current = current
        }
        if let max = try container.decodeIfPresent(Double.self, forKey: .max) {
            self.max = max
        }
        if let min = try container.decodeIfPresent(Double.self, forKey: .min) {
            self.min = min
        }
    }

}

class WeatherModel: Decodable {

    var wind:WindModel?
    var weather:[WeatherDetail]?
    var temperature:TemperatureModel?
    var date = Date()
    var cityName = ""
    var cityDetails:CityDetails?
    var dateStr:String {
        return WeatherDateFormatter.stringFromDate(date: self.date)
    }
    
    var timeStr:String{
        return WeatherDateFormatter.stringFromDate("h:mm a", date: self.date)
    }

    var statusCode:String = "200"
    var statusMessage:String = ""
    var errorMessage:String?

    enum CodingKeys: String, CodingKey {
        case wind = "wind"
        case weather = "weather"
        case temperature = "main"
        case date = "dt_txt"
        case cityName = "name"
        case cityDetails = "sys"
        case statusCode = "cod"
        case statusMessage = "message"
    }

    public init(){

    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let cityName = try container.decodeIfPresent(String.self, forKey: .cityName) {
            self.cityName = cityName
        }
        
        if let cityDetails = try container.decodeIfPresent(CityDetails.self, forKey: .cityDetails) {
            self.cityDetails = cityDetails
            self.cityDetails?.cName = self.cityName
        }

        if let wind = try container.decodeIfPresent(WindModel.self, forKey: .wind) {
            self.wind = wind
        }
        
        if let weather = try container.decodeIfPresent([WeatherDetail].self, forKey: .weather) {
            self.weather = weather
        }

        if let temperature = try container.decodeIfPresent(TemperatureModel.self, forKey: .temperature) {
            self.temperature = temperature
        }

        if let dateStr = try container.decodeIfPresent(String.self, forKey: .date) {
            self.date = WeatherDateFormatter.dateFromString(str: dateStr)
        }

        if let statusMessage = try container.decodeIfPresent(String.self, forKey: .statusMessage) {
            self.statusMessage = statusMessage
        }

        if self.statusMessage.count > 0 , let statusCode = try container.decodeIfPresent(String.self, forKey: .statusCode) {
            self.statusCode = statusCode
        }

        if(self.statusCode != "200"){
            errorMessage = "Unable to fetch data from server."
        }

    }

}
