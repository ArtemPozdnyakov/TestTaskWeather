//
//  StartView.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 11/15/20.
//

import UIKit
import RxCocoa
import RxSwift

protocol StartViewProtocol: UIView {
    var collectionView: UICollectionView { get }
    var array: [CurrentWeatherModel] { get set }
    var didSelectCell: PublishSubject<IndexPath> { get set }
    var searchSubject: PublishSubject<String> { get set }
    
    func setupSearchBar(nc: UINavigationController?, ni: UINavigationItem)
}

class StartViewImpl: UIView, StartViewProtocol {
    
    var didSelectCell = PublishSubject<IndexPath>()
    var searchSubject = PublishSubject<String>()
    
    var array: [CurrentWeatherModel] = [] {
        didSet {
            if array.count == 10 {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    var collectionView: UICollectionView = {
        return $0
    }(UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout()))
    
    private var searchBar = UISearchBar()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initView()
    }
    
    func initView() {
        setupCollectionView()
        
    }
    
    func setupCollectionView() {
        collectionView =  UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = #colorLiteral(red: 0.4165681005, green: 0.3878802657, blue: 0.7815238833, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 300, right: 0)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 10
        self.addSubview(collectionView)
        collectionView.register(CityViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupSearchBar(nc: UINavigationController?, ni: UINavigationItem) {
        nc?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Night"), for: UIBarMetrics(rawValue: 0)!)
        searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBar.placeholder = "Enter city..."
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.sizeToFit()
        ni.titleView = searchBar
    }
}

//MARK: - Extension - UICollectionViewDelegateFlowLayout
extension StartViewImpl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 30, height: 65)
    }
}

//MARK: - Extension - UICollectionViewDelegate, UICollectionViewDataSource
extension StartViewImpl: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if array.count == 0 {
            return 10
        }
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CityViewCell
        
        if array.count != 0 {
            cell.updateCell(model: array[indexPath.row])
            cell.isHiddenView(isHidden: false)
        } else {
            cell.isHiddenView(isHidden: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell.onNext(indexPath)
    }
}

//MARK: - UISearchBarDelegate
extension StartViewImpl: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        guard let textCity = searchBar.text else { return }
        searchSubject.onNext(textCity)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
