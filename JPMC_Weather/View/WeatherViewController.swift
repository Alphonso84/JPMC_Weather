//
//  ViewController.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/1/23.
//

import UIKit
import SwiftUI
import Combine

class WeatherViewController: UIViewController {
    // MARK: - Properties
    lazy var hostingController = UIHostingController(rootView: WeatherView(viewModel: viewModel))
    let viewModel = WeatherViewModel()
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let scrollView = UIScrollView()
    private var favoritesObserver: AnyCancellable?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupWeatherView()
        setupSearchBar()
        setupTableView()
        favoritesObserver = viewModel.$favoriteCities.sink { [weak self] _ in
               DispatchQueue.main.async {
                   self?.tableView.reloadData()
               }
           }
    }

    // MARK: - UI Setup
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

// MARK: - TableView Delegate & DataSource & UISearchBarDelegate
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
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favoriteCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for:indexPath)
        cell.textLabel?.text = viewModel.favoriteCities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // When a favorite city is tapped, fetch its weather data
        let city = viewModel.favoriteCities[indexPath.row].replacingOccurrences(of: " ", with: "%20")
        viewModel.fetchWeatherData(for: city) { error in
            if let error = error {
                print("Error fetching weather data: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityName = viewModel.favoriteCities[indexPath.row]
            viewModel.favoriteCities.remove(at: indexPath.row)
            viewModel.saveFavoriteCities()
            viewModel.removeFavoriteCity(byName: cityName)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
