//
//  ParseJSON.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 11/15/20.
//

import Foundation

protocol ParseJSONProtocol {
    func parseJSONWeather(withData data: Data) -> CurrentWeatherModel?
    func parseJSONGeo(withData data: Data) -> CurrentCoordinatesModel?
}

class ParseJSON: ParseJSONProtocol {
        
    //Parse data Weather
    func parseJSONWeather(withData data: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let currentWhetherData = try decoder.decode(WelcomeWeather.self, from: data)
            guard let currentWeather = CurrentWeatherModel(currentWeatherData: currentWhetherData)
            else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    //Parse data Coordinates
    func parseJSONGeo(withData data: Data) -> CurrentCoordinatesModel? {
        let decoder = JSONDecoder()
        
        do {
            let currentWhetherData = try decoder.decode(WelcomeCoordinates.self, from: data)
            guard let currentWeather = CurrentCoordinatesModel(currentWeatherData: currentWhetherData)
            else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
