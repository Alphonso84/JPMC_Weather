//
//  WeatherViewModel.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/5/23.
//

import UIKit
import Combine

class WeatherViewModel: ObservableObject {
    @Published private var model: WeatherData?
    @Published var weatherIconImage: UIImage?
    @Published var _city: String = ""
    
    var weatherIcon: String? {
        model?.weather.first?.icon
    }
    
    var temperature: String {
        if let temp = model?.main.temp {
            let fahrenheitTemp = kelvinToFahrenheit(temp)
            return "\(Int(fahrenheitTemp))"
        } else {
            return "N/A"
        }
    }
    
    var weatherDescription: String {
        model?.weather.first?.description.capitalized ?? "Unknown"
    }
    
    func kelvinToFahrenheit(_ kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9 / 5 + 32
    }
    
    func fetchWeatherIcon() {
            guard let iconCode = weatherIcon else {
                return
            }
            let iconUrlString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
            guard let url = URL(string: iconUrlString) else {
                return
            }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self?.weatherIconImage = image
                    print(self?.weatherIconImage)
                }
            }
            task.resume()
        }
    
    func fetchWeatherData(for city:String, completion: @escaping (Error?) -> Void) {
        //In actual app I would never store API Key here.
        self._city = city
        let apiKey = "da24ab0246307b1f6a19d127960a39f5"
        let locationUrlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(37.7652)&lon=\(-122.2416)&appid=\(apiKey)"
        print(locationUrlString)
        let cityUrlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        print(cityUrlString)
        guard let url = URL(string:cityUrlString) else {
            completion(NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "NoData", code: -1, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                print(weatherData)
                self?.model = weatherData
                self?.fetchWeatherIcon()
                completion(nil)
            } catch {
                completion(error)
            }
        }
        task.resume()
    }
}



