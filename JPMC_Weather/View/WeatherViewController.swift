//
//  ViewController.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/1/23.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {
    lazy var hostingController = UIHostingController(rootView: WeatherView(viewModel: viewModel))
    let viewModel = WeatherViewModel()
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupWeatherView()
        setupSearchBar()
        setupTableView()
    }

    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupWeatherView() {
        addChild(hostingController)
        scrollView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 80),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -80)
        ])
    }

    func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search City"
        definesPresentationContext = true
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: hostingController.view.bottomAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])
        tableView.tableHeaderView = searchController.searchBar
    }
}


//TableView Delegate DataSource
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            print("Search text: \(searchText)")
            viewModel._city = searchText.replacingOccurrences(of: " ", with: "%20")
            viewModel.fetchWeatherData(for:viewModel._city) { error in
                if let error = error {
                    print("Error fetching weather data: \(error)")
                }
            }
        }
            searchBar.resignFirstResponder()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for:indexPath)
        return cell
    }
}

