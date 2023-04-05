//
//  WeatherView.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/3/23.
//

import UIKit
import SwiftUI

struct WeatherView: View {
    var body: some View {
        VStack(spacing:20) {
            Image(systemName:"sun.min.fill")
            Text("80")
                .font(.system(size: 27))
            Text("Partly Cloudy")
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}


