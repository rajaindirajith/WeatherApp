//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by rajai.techmantra on 5/20/20.
//  Copyright © 2020 rajai.techmantra. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {

    let manager  = MockWeatherAPIManager()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetWeatherByLocation_SuccessResponse() {
        
        let expectation = self.expectation(description: "get current location weather")
        var serviceResponse:CurrentLocationWeatherResponse?
        manager.fetchWeather(byLoationLat: 20.5937, lon: 78.9629) { (response) in
            serviceResponse = response as? CurrentLocationWeatherResponse
            XCTAssertNotNil(serviceResponse, "response should not be null")
            XCTAssertNil(serviceResponse?.errorMessage, "response should not have error response")
            XCTAssert(serviceResponse?.statusCode == "200", "status code should be 200")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
           
           
    }
    
    func testGetWeatherByLocation_FailResponse() {
        let expectation = self.expectation(description: "get current location weather")
        var serviceResponse:CurrentLocationWeatherResponse?
        manager.fetchWeather(byLoationLat: 0.00, lon: 0.00) { (response) in
            serviceResponse = response as? CurrentLocationWeatherResponse
            XCTAssertNotNil(serviceResponse?.errorMessage, "response should have error response")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
           
           
    }

    func testGetWeatherByCities_SuccessResponse() {
        
        let expectation = self.expectation(description: "get Citys weather response")
        var serviceResponse:CityWeatherResponse?
        manager.fetchWeather(byCityName: "London") { (response) in
            serviceResponse = response as? CityWeatherResponse
            XCTAssertNotNil(serviceResponse, "response should not be null")
            XCTAssertNil(serviceResponse?.errorMessage, "response should not have error response")
            XCTAssert(serviceResponse?.statusCode == "200", "status code should be 200")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
           
           
    }
    
    func testGetWeatherByCities_FailResponse() {
        
         let expectation = self.expectation(description: "get Citys weather response")
               var serviceResponse:CityWeatherResponse?
               manager.fetchWeather(byCityName: "x") { (response) in
                   serviceResponse = response as? CityWeatherResponse
                   XCTAssertNotNil(serviceResponse?.errorMessage, "response should have error response")
                    expectation.fulfill()
               }
               
            self.waitForExpectations(timeout: 10.0, handler: nil)
           
           
    }

}
