//
//  CurrentWeatherModel.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation

struct CurrentWeatherModel {
    let nameCity: String
    let temperature: Int
    let feelsLikeTemperature: Int
    let pressure: Int
    let windSpeed: Double
    
    let conditionCode: String
    var iconCode: String {
        switch conditionCode {
        case "thunderstorm" : return "cloud.bolt.fill"
        case "snow" : return "snow"
        case "heavy-rain": return "cloud.heavyrain.fill"
        case "rain" : return "cloud.drizzle.fill"
        case "partly-cloudy" : return "cloud.fill"
        case "clear" : return "sun.max.fill"
        default: return "cloud.fill"
        }
    }
    
    
    init?(currentWeatherData: WelcomeWeather) {
        let name = currentWeatherData.info.tzinfo.name.components(separatedBy: "/")
        nameCity = name[1]
        print(name[1])
        temperature = currentWeatherData.fact.temp
        feelsLikeTemperature = currentWeatherData.fact.feelsLike
        conditionCode = currentWeatherData.fact.condition
        pressure = currentWeatherData.fact.pressureMm
        windSpeed = currentWeatherData.fact.windSpeed
    }
}
