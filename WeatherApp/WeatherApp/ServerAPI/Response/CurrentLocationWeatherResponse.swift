//
//  CurrentLocationWeatherResponse.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import Foundation


class LocationCordinate: Decodable{
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
       public init(){
           
       }
    
       
       required public init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
           
           if let latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) {
               self.latitude = latitude
           }
           if let longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) {
               self.longitude = longitude
           }
        
       }
    
}

class CityDetails: Decodable {
    
    var cId:Int = 0
    var cName:String = ""
    var cCoordinate:LocationCordinate?
    var cCountry:String?
    var timeZone:Int?
    var sunrise:Int?
    var sunset:Int?
    var cityCountryName:String {
        var title = cName
           
           if let country = cCountry {
               title += country.count > 0 ? ", \(country)" : country
           }
        return title
    }
    
    enum CodingKeys: String, CodingKey {
        case cId = "id"
        case cName = "name"
        case cCoordinate = "coord"
        case cCountry = "country"
        case timeZone = "timezone"
    }
    
    
       public init(){
           
       }
    
       
       required public init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
           
           if let cId = try container.decodeIfPresent(Int.self, forKey: .cId) {
               self.cId = cId
           }
           if let cName = try container.decodeIfPresent(String.self, forKey: .cName) {
               self.cName = cName
           }
           
           if let cCoordinate = try container.decodeIfPresent(LocationCordinate.self, forKey: .cCoordinate) {
               self.cCoordinate = cCoordinate
           }
           
           if let cCountry = try container.decodeIfPresent(String.self, forKey: .cCountry) {
               self.cCountry = cCountry
           }
           
           if let timeZone = try container.decodeIfPresent(Int.self, forKey: .timeZone) {
               self.timeZone = timeZone
           }
        
       }
    
    
}
class CurrentLocationWeatherResponse: BaseResponse ,Decodable {
   
    var statusCode:String = "0"
    var statusMessage:Int = 0
    var errorMessage:String?
    var itemsCount:Int = 0
    var itemList:[WeatherModel]?
    var cityDetails:CityDetails?
    
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "cod"
        case statusMessage = "message"
        case itemsCount = "cnt"
        case itemList = "list"
        case cityDetails = "city"
    }
    
    
    public override init(){
           
       }
    
       
       required public init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
           
           if let statusCode = try container.decodeIfPresent(String.self, forKey: .statusCode) {
               self.statusCode = statusCode
            if(self.statusCode != "200"){
                errorMessage = "Unable to fetch data from server."
            }
           }
           if let statusMessage = try container.decodeIfPresent(Int.self, forKey: .statusMessage) {
               self.statusMessage = statusMessage
           }
           
           if let itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount) {
               self.itemsCount = itemsCount
           }
           
           if let itemList = try container.decodeIfPresent([WeatherModel].self, forKey: .itemList) {
               self.itemList = itemList
           }
           
           if let cityDetails = try container.decodeIfPresent(CityDetails.self, forKey: .cityDetails) {
               self.cityDetails = cityDetails
           }
          
       }
    
    
}
