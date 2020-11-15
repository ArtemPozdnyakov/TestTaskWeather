//
//  DetailsViewController.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let detailsView: DetailsViewProtocol
    private var network: Networking
    
    init(detailsView: DetailsViewProtocol, network: Networking = NetworkWether()) {
        self.detailsView = detailsView
        self.network = network
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
        network.detailCity.subscribe { city in
            self.setupScreen(model: city.element!)
        }
    }
    
    func detailCity(city: String) {
        self.network.performRequestCoordinates(city: city, varinant: 1)
    }
    
    func setupScreen(model: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.detailsView.isHiddenView(isHidden: false)
            self.detailsView.updateView(model: model)
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
