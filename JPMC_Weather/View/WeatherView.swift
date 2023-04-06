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
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Spacer()
            if let weatherIcon = viewModel.weatherIconImage {
                Image(uiImage:weatherIcon)
            }
            
            Text(viewModel._city.replacingOccurrences(of: "%20", with:" "))
                .fontWeight(.heavy)
            Text(viewModel.temperature)
                .font(.system(size: 57))
            Text(viewModel.weatherDescription)
            Spacer()
        }
        .onAppear() {
            viewModel.fetchWeatherData(for: viewModel._city) { error in
                if let error = error {
                    print("Error fetching weather data: \(error)")
                } else {
                    viewModel.fetchWeatherIcon()
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


