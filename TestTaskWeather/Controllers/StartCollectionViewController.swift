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
//    var detailsDelegate: UpdateDetailsProtocol?
    
    var countCity = 0
    var cancelHiddenCell = false
    var cityForDetailsVC = ""
    let standarCity = ["Moscow", "London", "Paris", "Tokyo", "Bangkok", "Kiev", "Madrid", "Minsk", "Rome", "Prague"]
    
    var resultCity: [CurrentWeatherModel] = [] {
        didSet {
            if resultCity.count == 10 {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.cancelHiddenCell = true
                }
            }
        }
    }
    
    private var searchBar: UISearchBar = {
        $0.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        $0.placeholder = "Enter city..."
        $0.showsCancelButton = true
        return $0
    }(UISearchBar())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.geoDelegate = self
        
        setupCollectionView()
        setupSearchBar()
        startLoadingWeather(city: standarCity, item: countCity)
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
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func startLoadingWeather(city: [String], item: Int){
        network.performRequestGeo(withUrlString:"https://geocode-maps.yandex.ru/1.x/?apikey=93fcd8aa-a521-479c-a5cd-5036b0c72b56&format=json&geocode=\(city[item])", varinant: 0)
    }
    
}

extension StartCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 65)
    }
    
}

extension StartCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CityViewCell
        
        if resultCity.count != 0 {
            cell.nameCity.text = resultCity[indexPath.row].nameCity
            cell.tempInCity.text = "\(resultCity[indexPath.row].temperature) C°"
            cell.weatherImage.image = UIImage(systemName: resultCity[indexPath.row].iconCode)
            cell.backgroundColor = #colorLiteral(red: 0.5748289227, green: 0.5990194678, blue: 1, alpha: 1)
        }
        
        if !cancelHiddenCell {
            cell.nameCity.text = "Loading..."
            cell.greayView.isHidden = true
            cell.tempInCity.isHidden = true
            cell.weatherImage.isHidden = true
        } else {
            cell.greayView.isHidden = false
            cell.tempInCity.isHidden = false
            cell.weatherImage.isHidden = false
        }
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 7
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.20
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if resultCity.count == 10 {
            let vc = DetailsViewController(detailsView: DetailsViewImpl(), city: nil)
            vc.setupScreen(model: resultCity[indexPath.row])
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

//Loading city in massive
extension StartCollectionViewController: NetworkGeoDelegate {
    func addInfoWeather(_: NetworkWether, with currentWeather: CurrentWeatherModel) {
        resultCity.append(currentWeather)
        countCity += 1
        if countCity != 10 {
            startLoadingWeather(city: standarCity, item: countCity)
        }
    }
}

extension StartCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        cityForDetailsVC = text
    }
    
    // Go to DetailsVC
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let vc = DetailsViewController(detailsView: DetailsViewImpl(), city: cityForDetailsVC)
        vc.firstStart(answer: true)
        present(vc, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}


