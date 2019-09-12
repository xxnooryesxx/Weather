//
//  WeatherModel.swift
//  WeatherForecastRx
//
//  Created by 愤怒大葱鸭 on 9/11/19.
//  Copyright © 2019 愤怒大葱鸭. All rights reserved.
//

import Foundation


struct WeatherModel: Codable {
    var weather: [WeatherDetails]
    var main: Temps
    var name: String
}

struct WeatherDetails: Codable {
    var main: String
    var description: String
    var icon: String
}

struct Temps: Codable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
}


//forecast

struct ForecastWeather: Codable {
    var list: [FutureContent]
    var city: Cityinfo
}

struct FutureContent: Codable {
    var dt: Int
    var weather: [WeatherDetails]
    var main: Temps
}

struct Cityinfo: Codable {
    var name: String
}

struct Cities {
    var city: String
    var lattitude: Double
    var lontitude: Double
}
