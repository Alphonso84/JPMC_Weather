//
//  LocationManager.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/6/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error.localizedDescription)")
    }
}

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var onLocationUpdate: ((CLLocation) -> Void)?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            onLocationUpdate?(location)
        }
    }
}
