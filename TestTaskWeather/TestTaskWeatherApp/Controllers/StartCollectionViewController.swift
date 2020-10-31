//
//  StartTableViewController.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import UIKit

protocol UpdateDetailsProtocol {
    func setupScreen(model: CurrentWeatherModel)
}

class StartCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var network = NetworkWether()
    private var searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.geoDelegate = self
        
        setupCollectionView()
        setupSearchBar()
        startLoadingWeather(city: network.standarCity)
    }
    
    func setupCollectionView() {
        collectionView =  UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = #colorLiteral(red: 0.4165681005, green: 0.3878802657, blue: 0.7815238833, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 300, right: 0)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 10
        view.addSubview(collectionView)
        collectionView.register(CityViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupSearchBar() {
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Night"), for: UIBarMetrics(rawValue: 0)!)
        searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBar.placeholder = "Enter city..."
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func startLoadingWeather(city: [String]){
        network.performRequestCoordinates(city: network.standarCity[network.resultCity.count], varinant: 0)
    }
}


//MARK: - Extension
extension StartCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 65)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension StartCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CityViewCell
        
        if network.resultCity.count != 0 {
            cell.updateCell(model: network.resultCity[indexPath.row])
            cell.isHiddenView(isHidden: false)
        } else {
            cell.isHiddenView(isHidden: true)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if network.resultCity.count == 10 {
            let vc = DetailsViewController(detailsView: DetailsViewImpl())
            vc.setupScreen(model: network.resultCity[indexPath.row])
            present(vc, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Loading...", message: "Please wait.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}

//MARK: - NetworkGeoDelegate
//Loading city in massive
extension StartCollectionViewController: NetworkGeoDelegate {
    func addInfoWeather(with currentWeather: [CurrentWeatherModel]) {
        collectionView.reloadData()
    }
}

//MARK: - UISearchBarDelegate
extension StartCollectionViewController: UISearchBarDelegate {
    
    // Go to DetailsVC
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        let vc = DetailsViewController(detailsView: DetailsViewImpl())
        guard let textCity = searchBar.text else { return }
        vc.city = textCity
        present(vc, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}


