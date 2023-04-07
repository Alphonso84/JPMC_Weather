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
    @State private var showAlert = false
    
    //This was a workaround I found from stackOverflow since @State showAlert alone was not updating everytime a new favorite was added. I need to do more research to fully understand how custom bindings work fully. 
    private var alertBinding: Binding<Bool> {
            Binding<Bool>(
                get: { showAlert },
                set: { newValue in
                    if newValue {
                        showAlert = true
                    }
                }
            )
        }

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            // Favorite button
            HStack {
                Spacer()
                Button(action: {
                    isFavorite.toggle()
                    if isFavorite {
                        // Add city to favorites if it's not already there
                        viewModel.favoriteCities.append(viewModel.cityName)
                        viewModel.saveFavoriteCities()
                        alertBinding.wrappedValue = true
                    } else {
                        // Remove city from favorites if it's there
                        viewModel.favoriteCities.removeAll(where: { $0 == viewModel.cityName })
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
                .offset(y: 100)
            }
            // Weather icon
            if let weatherIcon = viewModel.weatherIconImage {
                Image(uiImage: weatherIcon)
            }
            // City name
            Text(viewModel.cityName)
                .fontWeight(.heavy)
            // Temperature
            Text(viewModel.temperature)
                .font(.system(size: 57))
            // Weather description
            Text(viewModel.weatherDescription)
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("City Added to Favorites"),
                  message: Text("You have added \(viewModel.cityName) to your favorite cities."),
                  dismissButton: .default(Text("OK")))
        }
        // Check if city is a favorite when cityName changes
        .onChange(of: viewModel.cityName, perform: { newValue in
            isFavorite = viewModel.favoriteCities.contains(viewModel.cityName)
        })
        // Check if city is a favorite when favoriteCities changes
        .onChange(of: viewModel.favoriteCities, perform: { newValue in
            isFavorite = viewModel.favoriteCities.contains(viewModel.cityName)
        })
        // Fetch weather data when the view appears
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
}
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel())
    }
}


