//
//  CurrentWeatherData.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation

// MARK: - Welcome
struct WelcomeCoordinates: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
    let featureMember: [FeatureMember]
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let point: Point

    enum CodingKeys: String, CodingKey {
        case point = "Point"
    }
}

// MARK: - Point
// lat and lon
struct Point: Codable {
    let pos: String
}
