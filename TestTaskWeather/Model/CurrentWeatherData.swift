//
//  File.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import Foundation

// MARK: - Welcome
struct WelcomeWeather: Codable {
    let info: Info
    let fact: Fact
}

// MARK: - Fact
struct Fact: Codable {
    let temp: Int
    let feelsLike: Int
    let condition: String
    let windSpeed: Double
    let pressureMm: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case condition
        case windSpeed = "wind_speed"
        case pressureMm = "pressure_mm"
    }
}

// MARK: - Info
struct Info: Codable {
    let tzinfo: Tzinfo
}

// MARK: - Tzinfo
struct Tzinfo: Codable {
    let name: String
}
