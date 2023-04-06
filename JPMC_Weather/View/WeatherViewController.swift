//
//  ViewController.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/1/23.
//

import UIKit
import SwiftUI

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

class WeatherViewController: UIViewController {
    let weatherView = WeatherView()
    let viewModel = WeatherViewModel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupWeatherView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupWeatherView() {
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

