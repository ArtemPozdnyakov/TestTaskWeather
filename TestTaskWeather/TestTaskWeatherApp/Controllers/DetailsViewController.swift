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
            self.network.performRequestCoordinates(city: city, varinant: 1)
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
    
    func setupScreen(model: CurrentWeatherModel) {
        detailsView.isHiddenView(isHidden: false)
        detailsView.updateView(model: model)
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
            self.detailsView.isHiddenView(isHidden: false)
            self.detailsView.updateView(model: currentWeather)
        }
    }
}
