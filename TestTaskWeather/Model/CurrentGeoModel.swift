//
//  CurrentWeatherModel.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation

struct CurrentGeoModel {
    let lat: String
    let lon: String
    
    init?(currentWeatherData: WelcomeGeo) {
        let poss = currentWeatherData.response.geoObjectCollection.featureMember[0].geoObject.point.pos.components(separatedBy: " ")
        lon = poss[0]
        lat = poss[1]
        print(lat)
        print(lon)
    }
}
