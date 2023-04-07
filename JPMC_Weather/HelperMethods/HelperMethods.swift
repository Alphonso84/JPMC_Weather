//
//  HelperMethods.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/6/23.
//

import Foundation


extension Double {
    //Converts API Kelvin Temp to Fahrenheit
    func kelvinToFahrenheit() -> Double {
        return (self - 273.15) * 9 / 5 + 32
    }
}
