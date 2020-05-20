//
//  SearchScreenViewModel.swift
//  Weather
//
//  Created by rajaindirajith on 5/21/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import Foundation




class SearchScreenViewModel:NSObject {
    
    var dataSource:[WeatherModel] = [WeatherModel]()
    weak var screenDelegate: WeatherSearchDelegate!
    
    var weatherAPIManager: WeatherAPIManagable!
    let dispatchGroup = DispatchGroup()
    
    required init(withScreenDelegate delegate:WeatherSearchDelegate) {
        super.init()
        screenDelegate = delegate
        weatherAPIManager = WeatherAPIManager()
    }
    
    func setSearchText(_ text:String?) {
        if let trimmedString = text?.trimmingCharacters(in: .whitespaces) , trimmedString.count > 0 {
            let cities =  trimmedString.components(separatedBy: ",")
            if cities.count >= 3 && cities.count <= 7{
                fetchWeatherForCities(cities)
                dataSource.removeAll()
            }else {
                screenDelegate?.didFinishSearch("Please enter minimum 3 & maximum 7 cities name by , seperated to search")
            }
        }else {
            screenDelegate?.didFinishSearch("Please enter minimum 3 & maximum 7 cities name by , seperated to search")
        }
    }
        
    func addWeatherItemToDataSource(_ item:WeatherModel){
        dataSource.append(item);
        screenDelegate?.didFinishSearch(nil)
    }
    
    func responseErrorCount(_ count:Int){
        if(count > 0){
            screenDelegate?.didFinishSearch("Error in getting \(count) city Weather")
        }
    }
    
    //Fetching Weather for the search cities
    func fetchWeatherForCities(_ cities:[String]) {
        
        screenDelegate?.showSearchLoader(true)
        DispatchQueue.global(qos: .background).async {
            var errorCount = 0
            for cityName in cities {
                self.dispatchGroup.enter()
                self.weatherAPIManager.fetchWeather(byCityName: cityName) { [weak self] (response) in
                    DispatchQueue.main.async {
                        if let responseRef = response as?  CityWeatherResponse ,let weatherItem = responseRef.weatherItem, responseRef.errorMessage == nil{
                            self?.addWeatherItemToDataSource(weatherItem)
                        }else {
                            errorCount = errorCount + 1
                        }
                    }
                    self?.dispatchGroup.leave()
                }
            }

            self.dispatchGroup.wait()
            self.dispatchGroup.notify(queue: .main) {
                self.screenDelegate?.showSearchLoader(false)
                self.responseErrorCount(errorCount)
            }
        }
        
    }
          
}

