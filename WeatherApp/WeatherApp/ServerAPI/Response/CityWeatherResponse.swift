//
//  CityWeatherResponse.swift
//  Weather
//
//  Created by rajaindirajith on 5/21/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import Foundation


class CityWeatherResponse: BaseResponse {
    var weatherItem:WeatherModel?
    var statusCode:String = "200"
    var errorMessage:String?
}
