//
//  ViewController.swift
//  JPMC_Weather
//
//  Created by Alphonso Sensley II on 4/1/23.
//

import UIKit

class WeatherViewController: UIViewController {
    var tempLabel = UILabel()
    var descriptionLabel = UILabel()
    var imageView : UIImageView {
        let view = UIImageView(image:  UIImage(systemName: "sun.min.fill"))
        view.contentMode = .scaleAspectFit
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setupStackView()
        setupLabels()
        view.backgroundColor = .systemBackground
    }
    
    func setupStackView() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            stackView.widthAnchor.constraint(equalToConstant: 100)
        ])
        stackView.axis = .vertical
        stackView.contentMode = .scaleAspectFill
        stackView.spacing = 10
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    func setupLabels() {
        tempLabel.text = "80"
        tempLabel.textColor = .label
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.boldSystemFont(ofSize: 24)
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 12)
        descriptionLabel.textColor = .label
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "This is a test"
    }
}

