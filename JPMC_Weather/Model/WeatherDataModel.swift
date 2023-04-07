//
//  WeatherDataModel.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/1/23.
//

import Foundation
import UIKit

struct WeatherData: Codable {
    let coord: Coord?
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    var favorites: [String]?
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let groundLevel: Int?

    private enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity, seaLevel = "sea_level", groundLevel = "grnd_level"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Codable {
    let speed: Double
    let degree: Int
    let gust: Double?

    private enum CodingKeys: String, CodingKey {
        case speed, gust
        case degree = "deg"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

