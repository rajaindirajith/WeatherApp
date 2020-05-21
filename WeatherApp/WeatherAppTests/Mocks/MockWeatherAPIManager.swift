//
//  MockWeatherAPIManager.swift
//  WeatherAppTests
//
//  Created by rajai.techmantra on 5/21/20.
//  Copyright © 2020 rajai.techmantra. All rights reserved.
//

import Foundation
@testable import WeatherApp

class MockWeatherAPIManager {
    
}

extension MockWeatherAPIManager: WeatherAPIManagable {
    func fetchWeather(byLoationLat lat: Double, lon: Double, completionHandler: @escaping RequestCompletionHandler) {
        
       var response =  CurrentLocationWeatherResponse()
        if lat == 20.5937 && lon == 78.9629 {
            
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockWeatherCurrentLocationData", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                let output = try? JSONDecoder().decode(CurrentLocationWeatherResponse.self, from: data)
                else {
                    response.errorMessage = "error in loading data"
                    response.statusCode = "0"
                    completionHandler(response)
                    return
                }
            response = output
   
        }else {
            response.errorMessage = "error in loading data"
            response.statusCode = "0"
        }
        completionHandler(response)
    }
    
    func fetchWeather(byCityName city: String, completionHandler: @escaping RequestCompletionHandler) {
        
       let response =  CityWeatherResponse()
        if city == "London" {
             let bundle = Bundle(for: type(of: self))
             guard let url = bundle.url(forResource: "MockWeatherCitiesData", withExtension: "json"),
                       let data = try? Data(contentsOf: url),
                     let output = try? JSONDecoder().decode(WeatherModel.self, from: data)
                     else {
                         response.errorMessage = "error in loading data"
                         response.statusCode = "0"
                         completionHandler(response)
                         return
                     }
            response.statusCode = output.statusCode
            response.errorMessage = output.errorMessage
            response.weatherItem = output
        
             }else {
            response.errorMessage = "error in loading data"
            response.statusCode = "0"
        }
        
        
        
        completionHandler(response)
    }
    
}
