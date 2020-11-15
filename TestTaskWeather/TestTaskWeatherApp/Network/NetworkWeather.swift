//
//  NetworkWeather.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

protocol Networking {
    var countRequest: Int { get set }
    var cityFinish: PublishSubject<CurrentWeatherModel> { get }
    var detailCity: PublishSubject<CurrentWeatherModel> { get }
    
    func performRequestCoordinates(city: String, varinant: Int)
}

class NetworkWether: Networking {
    
    private let keyApiWeather = "cef9f267-1620-4535-9f7b-ff4018ed2a0f"
    private let keyApiCoordinates = "93fcd8aa-a521-479c-a5cd-5036b0c72b56"
    
    var standarCity = ["Moscow", "London", "Paris", "Tokyo", "Bangkok", "Kiev", "Madrid", "Minsk", "Rome", "Prague"]
    
    var cityFinish = PublishSubject<CurrentWeatherModel>()
    var detailCity = PublishSubject<CurrentWeatherModel>()
    
    var countRequest = 0 {
        didSet {
            if countRequest != 10 {
                self.performRequestCoordinates(city: standarCity[countRequest], varinant: 0)
            }
        }
    }
        
    let parseJSON: ParseJSONProtocol
    
    init(parseJSON: ParseJSONProtocol = ParseJSON()) {
        self.parseJSON = parseJSON
    }
    
    //MARK: - Get Request Network
    
    //Get coordinates city
    func performRequestCoordinates(city: String, varinant: Int) {
        
        guard let url = URL(string: "https://geocode-maps.yandex.ru/1.x/?apikey=\(keyApiCoordinates)&format=json&geocode=\(city)") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON.parseJSONGeo(withData: data) {
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
            
            if let currentWeather = self.parseJSON.parseJSONWeather(withData: data) {
                if varinant == 0 {
                    self.cityFinish.onNext(currentWeather)
                    self.countRequest += 1
                } else if varinant == 1 {
                    self.detailCity.onNext(currentWeather)
                }
            }
        }.resume()
    }
}
