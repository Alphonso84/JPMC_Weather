//
//  WeatherViewModel.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/5/23.
//

import UIKit
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    //MARK: - Properties
    @Published private var model: WeatherData?
    @Published var weatherIconImage: UIImage?
    @Published var _city: String = ""
    @Published var favoriteCities: [String] = []
    let locationManager = CLLocationManager()
    var location = CLLocation()
    
    var weatherIcon: String? {
        model?.weather.first?.icon
    }
    
    var cityName: String {
        guard let name = model?.name else {
            return "Search for a City"
        }
        return name
    }
    
    var temperature: String {
        if let temp = model?.main.temp {
            let fahrenheitTemp = temp.kelvinToFahrenheit()
            return "\(Int(fahrenheitTemp))"
        } else {
            return "N/A"
        }
    }
    
    var weatherDescription: String {
        model?.weather.first?.description.capitalized ?? "Unknown"
    }
    //MARK: - Init
    init() {
        loadFavoriteCities()
    }
    //MARK: - API Calls
    
    //Fetch Weather Icon base on iconCode from response
    //This method is called in fetchWeatherData
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
    
    func fetchWeatherData(for city: String? = nil, location: CLLocation? = nil, completion: @escaping (Error?) -> Void) {
        // API Key for OpenWeatherMap (should be stored securely in an actual app)
        let apiKey = "da24ab0246307b1f6a19d127960a39f5"
        var urlString: String = ""
        var latitude = Double()
        var longitude = Double()
        // If city name is provided, set up the API URL using city name
        if let city = city {
            self._city = city
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
            saveLastSearchedCity(city: self._city)
        }
        // If CLLocation object is provided, set up the API URL using latitude and longitude
        if let location = location {
            self.location = location
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        }
        // Ensure the API URL is valid
        guard let url = URL(string: urlString) else {
            completion(NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        // Create a URLSession data task to fetch weather data
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // If an error occurs, pass it to the completion handler
            if let error = error {
                completion(error)
                return
            }
            // Ensure data is received from the API
            guard let data = data else {
                completion(NSError(domain: "NoData", code: -1, userInfo: nil))
                return
            }
            // Attempt to decode the received data into a WeatherData object
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                print(weatherData)
                // Update the model and fetch the weather icon on the main thread
                DispatchQueue.main.async {
                    self?.model = weatherData
                    self?.fetchWeatherIcon()
                }
                completion(nil)
            } catch {
                // If decoding fails, pass the error to the completion handler
                completion(error)
            }
        }
        task.resume()
    }
   //MARK: - Favorite City Methods
    func saveFavoriteCities() {
        UserDefaults.standard.set(favoriteCities, forKey: "favoriteCities")
    }
    
    func loadFavoriteCities() {
        if let loadedFavoritesCities = UserDefaults.standard.array(forKey: "favoriteCities") as? [String] {
            favoriteCities = loadedFavoritesCities
        }
    }
    
    func removeFavoriteCity(byName cityName: String) {
        favoriteCities.removeAll(where: { $0 == cityName })
        saveFavoriteCities()
    }
    
//MARK: - Last Searched City Methods
    func saveLastSearchedCity(city: String) {
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
    }
    
    func loadLastSearchedCity() -> String? {
        return UserDefaults.standard.string(forKey: "lastSearchedCity")
    }
}



