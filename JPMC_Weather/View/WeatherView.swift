//
//  WeatherView.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/3/23.
//

import UIKit
import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(spacing:20) {
            Image(systemName:"sun.min.fill")
            Text(viewModel.temperature)
                .font(.system(size: 27))
            Text(viewModel.weatherDescription)
        }
        .onAppear() {
            viewModel.fetchWeatherData { error in
                if let error = error {
                    print("Error fetching weather data: \(error)")
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}


