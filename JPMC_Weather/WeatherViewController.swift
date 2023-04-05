//
//  ViewController.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/1/23.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupWeatherView()
    }
    
    func setupWeatherView() {
        let weatherView = WeatherView()
        let hostingController = UIHostingController(rootView: weatherView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 80),
            hostingController.view.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -80)
        ])
    }
}

