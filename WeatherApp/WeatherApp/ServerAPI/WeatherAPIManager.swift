//
//  WeatherAPIManager.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import Foundation

let apiKey = "72ca046bf83159c99d8a25832a0173ef"
let weatherAPIBaseURL = "http://api.openweathermap.org/data/2.5"
 typealias RequestCompletionHandler = (_ response: BaseResponse?) -> Void

protocol WeatherAPIManagable: class  {
    func fetchWeather(byLoationLat lat: Double, lon: Double, completionHandler:@escaping RequestCompletionHandler)
    func fetchWeather(byCityName city: String, completionHandler:@escaping RequestCompletionHandler)
}

class WeatherAPIManager:WeatherAPIManagable {
      
    func fetchWeather(byLoationLat lat: Double, lon: Double, completionHandler:@escaping RequestCompletionHandler) {

        let url = URL(string: weatherAPIBaseURL + "/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {  completionHandler(nil)
                return
            }

            print(String(data: data, encoding: .utf8)!)
            var response = CurrentLocationWeatherResponse()

            guard let responseRef = try? JSONDecoder().decode(CurrentLocationWeatherResponse.self, from: data) else {
                print("Unable to decode the data. Please try again")
                response.errorMessage  = "Unable to fetch data from server."
                completionHandler(response)
                return
            }
            response = responseRef
            completionHandler(response)

        }
        task.resume()

    }
    
    func fetchWeather(byCityName city: String, completionHandler:@escaping RequestCompletionHandler) {

        guard let cityEncodedStr = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) else {

            let response = CityWeatherResponse()
            response.errorMessage  = "Wrong URL."
            completionHandler(response)

            return
        }

        let url = URL(string: weatherAPIBaseURL + "/weather?q=\(cityEncodedStr)&appid=\(apiKey)&units=metric")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { completionHandler(nil)
                return
            }
            print(String(data: data, encoding: .utf8)!)

            let response = CityWeatherResponse()

            guard let weatherItem = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                print("Unable to decode the data. Please try again")
                response.errorMessage  = "Unable to fetch data from server."
                completionHandler(response)
                return
            }
            response.statusCode = weatherItem.statusCode
            response.errorMessage = weatherItem.errorMessage
            response.weatherItem = weatherItem
            completionHandler(response)
        }
        task.resume()

    }
}
