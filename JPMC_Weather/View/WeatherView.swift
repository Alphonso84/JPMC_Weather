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
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isFavorite.toggle()
                    if isFavorite {
                        viewModel.favoriteCities.append(viewModel.cityName)
                        print(viewModel.favoriteCities)
                        viewModel.saveFavoriteCities()
                    } else {
                        viewModel.favoriteCities.removeAll(where: { $0 == viewModel.cityName })
                        print(viewModel.favoriteCities)
                        viewModel.saveFavoriteCities()
                    }
                })
                {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                }
                .padding()
                .offset(y:100)
            }
            if let weatherIcon = viewModel.weatherIconImage {
                Image(uiImage: weatherIcon)
            }
            Text(viewModel.cityName)
                .fontWeight(.heavy)
            Text(viewModel.temperature)
                .font(.system(size: 57))
            Text(viewModel.weatherDescription)
            Spacer()
        }
        .onChange(of: viewModel.cityName, perform: { newValue in
            isFavorite = viewModel.favoriteCities.contains(viewModel.cityName)
        })
        .onChange(of: viewModel.favoriteCities, perform: { newValue in
            isFavorite = viewModel.favoriteCities.contains(viewModel.cityName)
        })
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


