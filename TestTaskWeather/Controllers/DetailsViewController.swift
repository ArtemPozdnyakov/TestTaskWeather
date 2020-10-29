//
//  DetailsViewController.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import UIKit

class DetailsViewController: UIViewController, UpdateDetailsProtocol {
    
    private let detailsView: DetailsViewProtocol
    
    var network = NetworkWether()
    
    var city = "" {
        didSet {
            self.network.performRequestGeo(withUrlString:"https://geocode-maps.yandex.ru/1.x/?apikey=93fcd8aa-a521-479c-a5cd-5036b0c72b56&format=json&geocode=\(city)", varinant: 1)
        }
    }
    
    init(detailsView: DetailsViewProtocol) {
        self.detailsView = detailsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.weatherDelegate = self
    }
    
    func firstStart(answer: Bool) {
        detailsView.nameCity.text = "Loading..."
        detailsView.weatherImage.isHidden = answer
        detailsView.tempInCity.isHidden = answer
        detailsView.tempWater.isHidden = answer
        detailsView.windSpeed.isHidden = answer
        detailsView.feelsLikeTempLabel.isHidden = answer
    }
    
    func setupScreen(model: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.detailsView.nameCity.text = model.nameCity
            self.detailsView.weatherImage.image = UIImage(systemName: model.iconCode)
            self.detailsView.tempInCity.text = "Температура \(model.temperature) C°"
            self.detailsView.tempWater.text = "Давление \(model.pressure)%"
            self.detailsView.windSpeed.text = "Ветер \(model.windSpeed) м/с"
            self.detailsView.feelsLikeTempLabel.text = "По ощущениям \(model.feelsLikeTemperature) C°"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

extension DetailsViewController: NetworkWetherDelegate {
    func updateInterface(_: NetworkWether, with currentWeather: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.firstStart(answer: false)
            self.detailsView.nameCity.text = currentWeather.nameCity
            self.detailsView.weatherImage.image = UIImage(systemName: currentWeather.iconCode)
            self.detailsView.tempInCity.text = "Температура \(currentWeather.temperature) C°"
            self.detailsView.tempWater.text = "Давление \(currentWeather.pressure)%"
            self.detailsView.windSpeed.text = "Ветер \(currentWeather.windSpeed) м/с"
            self.detailsView.feelsLikeTempLabel.text = "По ощущениям \(currentWeather.feelsLikeTemperature) C°"
        }
    }
}
