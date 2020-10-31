//
//  NetworkWeather.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation
import CoreLocation

protocol NetworkGeoDelegate {
    func addInfoWeather(with currentWeather: [CurrentWeatherModel])
}

protocol NetworkWetherDelegate {
    func updateInterface(_: NetworkWether, with currentWeather: CurrentWeatherModel)
}

class NetworkWether {
    
    private let keyApiWeather = "cef9f267-1620-4535-9f7b-ff4018ed2a0f"
    private let keyApiCoordinates = "93fcd8aa-a521-479c-a5cd-5036b0c72b56"
    
    let standarCity = ["Moscow", "London", "Paris", "Tokyo", "Bangkok", "Kiev", "Madrid", "Minsk", "Rome", "Prague"]
    
    var resultCity: [CurrentWeatherModel] = [] {
        didSet {
            if resultCity.count == 10 {
                DispatchQueue.main.async {
                    self.geoDelegate?.addInfoWeather(with: self.resultCity)
                    
                }
            } else {
                self.performRequestCoordinates(city: standarCity[resultCity.count], varinant: 0)
            }
        }
    }
    
    var weatherDelegate: NetworkWetherDelegate?
    var geoDelegate: NetworkGeoDelegate?
    
//MARK: - Get Request Network
    
    //Get coordinates city
    func performRequestCoordinates(city: String, varinant: Int) {
        
        guard let url = URL(string: "https://geocode-maps.yandex.ru/1.x/?apikey=\(keyApiCoordinates)&format=json&geocode=\(city)") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSONGeo(withData: data) {
                    self.performRequestWeather(lat: currentWeather.lat, lon: currentWeather.lon, varinant: varinant)
                }
            }
        }.resume()
    }
    
    //Get weather in city
    func performRequestWeather(lat: String, lon: String, varinant: Int) {
        
        var request = URLRequest(url: URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)&extra=true")!,timeoutInterval: Double.infinity)
        request.addValue(keyApiWeather, forHTTPHeaderField: "X-Yandex-API-Key")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            if let currentWeather = self.parseJSONWeather(withData: data) {
                if varinant == 0 {
                    self.resultCity.append(currentWeather)
                } else if varinant == 1 {
                    self.weatherDelegate?.updateInterface(self, with: currentWeather )
                }
            }
        }.resume()
    }
    
    
    
//MARK: - ParseJSON
    
    //Parse data Weather
    fileprivate func parseJSONWeather(withData data: Data) -> CurrentWeatherModel? {
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
    fileprivate func parseJSONGeo(withData data: Data) -> CurrentCoordinatesModel? {
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

