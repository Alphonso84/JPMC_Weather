//
//  WeatherView.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/3/23.
//

import UIKit
import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Spacer()
            if let weatherIcon = viewModel.weatherIconImage {
                Image(uiImage:weatherIcon)
            }
            
            Text(viewModel.cityName)
                .fontWeight(.heavy)
            Text(viewModel.temperature)
                .font(.system(size: 57))
            Text(viewModel.weatherDescription)
            Spacer()
        }
        .onAppear() {
            if let location = viewModel.locationManager.location {
                viewModel.fetchWeatherData(location: location) { error in
                    if let error = error {
                        print("Error fetching weather data: \(error)")
                    }
                }
            } else {
                if let lastSearchedCity = viewModel.loadLastSearchedCity() {
                    viewModel.fetchWeatherData(for: lastSearchedCity) { error in
                        if let error = error {
                            print("Error fetching weather data: \(error)")
                        }
                    }
                }
                
            }
        }
    }
    struct WeatherView_Previews: PreviewProvider {
        static var previews: some View {
            WeatherView(viewModel: WeatherViewModel())
        }
    }
}


