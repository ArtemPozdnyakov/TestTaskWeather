//
//  CurrentWeatherModel.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation

struct CurrentCoordinatesModel {
    let lat: String
    let lon: String
    
    init?(currentWeatherData: WelcomeCoordinates) {
        let poss = currentWeatherData.response.geoObjectCollection.featureMember[0].geoObject.point.pos.components(separatedBy: " ")
        lon = poss[0]
        lat = poss[1]
    }
}
