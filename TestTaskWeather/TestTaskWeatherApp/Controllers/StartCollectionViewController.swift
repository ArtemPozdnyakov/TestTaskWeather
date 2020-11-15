//
//  StartTableViewController.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import UIKit
import RxCocoa
import RxSwift

protocol UpdateDetailsProtocol {
    func setupScreen(model: CurrentWeatherModel)
}

class StartCollectionViewController: UIViewController {
    
    
    
    private let startView: StartViewProtocol?
    private var network: Networking
    
    init(startView: StartViewProtocol, network: Networking = NetworkWether()) {
        self.startView = startView
        self.network = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = startView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView?.setupSearchBar(nc: self.navigationController, ni: navigationItem)
        network.countRequest = 0
        citiFinish()
        didSelectCell()
        searchSubject()
    }
    
    func searchSubject() {
        startView?.searchSubject.subscribe({ city in
            DispatchQueue.main.async {
                let vc = DetailsViewController(detailsView: DetailsViewImpl())
                vc.detailCity(city: city.element!)
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    func citiFinish() {
        network.cityFinish.subscribe { city in
            self.startView?.array.append(city)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("complited")
        } onDisposed: {
            print("dispised")
        }
    }
    
    func didSelectCell() {
        startView?.didSelectCell.subscribe(onNext: { indexPath in
                let vc = DetailsViewController(detailsView: DetailsViewImpl())
                vc.setupScreen(model: (self.startView?.array[indexPath.row])!)
                self.present(vc, animated: true, completion: nil)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("complited")
        }, onDisposed: {
            print("dispised")
        })
    }
}

