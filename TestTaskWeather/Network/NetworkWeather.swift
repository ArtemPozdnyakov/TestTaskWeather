//
//  NetworkWeather.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation
import CoreLocation

protocol NetworkGeoDelegate {
    func addInfoWeather(_: NetworkWether, with currentWeather: CurrentWeatherModel)
}

protocol NetworkWetherDelegate {
    func updateInterface(_: NetworkWether, with currentWeather: CurrentWeatherModel)
}

class NetworkWether {
    
    private let key = "cef9f267-1620-4535-9f7b-ff4018ed2a0f"
    private let keyGeo = "93fcd8aa-a521-479c-a5cd-5036b0c72b56"
    
    var weatherDelegate: NetworkWetherDelegate?
    var geoDelegate: NetworkGeoDelegate?
    
    func performRequestGeo(withUrlString urlString: String, varinant: Int) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSONGeo(withData: data) {
                    self.performRequestWeather(lat: currentWeather.lat, lon: currentWeather.lon, varinant: varinant)
                }
            }
        }.resume()
    }
    
    func performRequestWeather(lat: String, lon: String, varinant: Int) {
        var request = URLRequest(url: URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)&extra=true")!,timeoutInterval: Double.infinity)
        request.addValue(key, forHTTPHeaderField: "X-Yandex-API-Key")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            if let currentWeather = self.parseJSONWeather(withData: data) {
                if varinant == 0 {
                    self.geoDelegate?.addInfoWeather(self, with: currentWeather)
                } else if varinant == 1 {
                    self.weatherDelegate?.updateInterface(self, with: currentWeather )
                }
            }
        }.resume()
    }
    
    
    
//MARK: - ParseJSON
    
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
    
    fileprivate func parseJSONGeo(withData data: Data) -> CurrentGeoModel? {
        let decoder = JSONDecoder()
        
        do {
            let currentWhetherData = try decoder.decode(WelcomeGeo.self, from: data)
            guard let currentWeather = CurrentGeoModel(currentWeatherData: currentWhetherData)
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

