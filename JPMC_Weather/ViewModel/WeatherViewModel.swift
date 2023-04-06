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
    
    //Computed Properties to prepare data for view
    var weatherIcon: String? {
            model?.weather.first?.icon
        }
    
    var temperature: String {
            if let temp = model?.main.temp {
                return "\(Int(temp))"
            } else {
                return "N/A"
            }
        }
    
    var weatherDescription: String {
        model?.weather.first?.description.capitalized ?? "Unknown"
        }
    
    func fetchWeatherData(completion: @escaping (Error?) -> Void) {
        //In actual app I would never store API Key here.
        let apiKey = "da24ab0246307b1f6a19d127960a39f5"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)"
           guard let url = URL(string:urlString) else {
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
                   self?.model = weatherData
                   completion(nil)
               } catch {
                   completion(error)
               }
           }
           task.resume()
       }
    
    
}



