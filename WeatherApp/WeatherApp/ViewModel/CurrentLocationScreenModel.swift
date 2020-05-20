//
//  CurrentLocationScreenModel.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherSearchDelegate: class  {
    func didFinishSearch(_ error:String?)
    func showSearchLoader(_ shouldShow:Bool)
}

class CurrentLocationScreenModel:NSObject {
    
    var dataSource:[OneDayWeatherModel] = [OneDayWeatherModel]()
    var locationTitle:String?
    weak var screenDelegate: WeatherSearchDelegate!
    
    let locationManager = CLLocationManager()
    
    var weatherAPIManager: WeatherAPIManagable!
    
    required init(withScreenDelegate delegate:WeatherSearchDelegate) {
        super.init()
        screenDelegate = delegate
        weatherAPIManager = WeatherAPIManager()
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func addWeatherItemToDataSource(_ itemList:[WeatherModel]?) {

        let sortedResponse = itemList?.sorted{ $0.date < $1.date  }
        dataSource .removeAll()
        sortedResponse?.forEach {
            let dateKey = $0.dateStr
            let filterArray = dataSource.filter { $0.sectionTitle == dateKey }
            var OneDayWeatherModelRef:OneDayWeatherModel
            if filterArray.count > 0{
                OneDayWeatherModelRef =  filterArray[0]
            }else {
                OneDayWeatherModelRef = OneDayWeatherModel()
                dataSource.append(OneDayWeatherModelRef)
            }
            OneDayWeatherModelRef.items.append($0)
            OneDayWeatherModelRef.sectionTitle = dateKey
        }

    }
    
    func fetchWeatherForLocation(_ location:CLLocation){
        
        screenDelegate?.showSearchLoader(true)
        weatherAPIManager.fetchWeather(byLoationLat: location.coordinate.latitude, lon: location.coordinate.longitude) { [weak self] (response) in
            DispatchQueue.main.async {
                self?.screenDelegate?.showSearchLoader(false)
                if let responseRef = response as?  CurrentLocationWeatherResponse {
                    self?.addWeatherItemToDataSource(responseRef.itemList)

                    var locTitle = ""
                    if let city = responseRef.cityDetails?.cName {
                        locTitle = city
                    }
                    if let country = responseRef.cityDetails?.cCountry {
                        locTitle += locTitle.count > 0 ? ", \(country)" : country
                    }
                    self?.locationTitle = locTitle
                    self?.screenDelegate?.didFinishSearch(responseRef.errorMessage)
                }else {
                    self?.screenDelegate?.didFinishSearch("Server error")
                }
            }
        }
        
    }
          
}


extension CurrentLocationScreenModel: CLLocationManagerDelegate {
   

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        fetchWeatherForLocation(location)
   }
   
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        screenDelegate?.didFinishSearch(error.localizedDescription)
   }
}
