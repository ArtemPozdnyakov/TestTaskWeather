//
//  File.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import UIKit

protocol DetailsViewProtocol: UIView {
    var nameCity: UILabel { get set}
    var weatherImage: UIImageView { get set }
    var tempInCity: UILabel { get set }
    var feelsLikeTempLabel: UILabel { get set }
    var tempWater: UILabel  { get set }
    var windSpeed: UILabel { get set }
}

class DetailsViewImpl: UIView, DetailsViewProtocol {
    
    internal var nameCity: UILabel = {
        $0.font = .systemFont(ofSize: 30)
        $0.text = "..."
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    internal var weatherImage: UIImageView = {
        $0.image = UIImage(systemName: "cloud.bolt.rain.fill")
        $0.tintColor = #colorLiteral(red: 0.8279205561, green: 0.7523292899, blue: 1, alpha: 1)
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    internal var tempInCity: UILabel = {
        $0.font = .systemFont(ofSize: 23)
        $0.text = "Текущая температура ..."
        $0.textColor = .white
        $0.backgroundColor = #colorLiteral(red: 0.6255869865, green: 0.6332743168, blue: 1, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    internal var feelsLikeTempLabel: UILabel = {
        $0.textColor = .white
        $0.backgroundColor = #colorLiteral(red: 0.6255869865, green: 0.6332743168, blue: 1, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 23)
        $0.text = "По ощущениям ..."
        return $0
    }(UILabel())
    
    internal var tempWater: UILabel = {
        $0.textColor = .white
        $0.backgroundColor = #colorLiteral(red: 0.6255869865, green: 0.6332743168, blue: 1, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 23)
        $0.text = "Давление ..."
        return $0
    }(UILabel())
    
    internal var windSpeed: UILabel = {
        $0.textColor = .white
        $0.backgroundColor = #colorLiteral(red: 0.6255869865, green: 0.6332743168, blue: 1, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 23)
        $0.text = "Скорость ветра ..."
        return $0
    }(UILabel())
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initView()
    }
    
    func initView() {
        backgroundColor = #colorLiteral(red: 0.4165681005, green: 0.3878802657, blue: 0.7815238833, alpha: 1)
        
        nameCity.pin(to: self).top(50).horizontally().height(100)
        weatherImage.pin(to: self).below(of: nameCity, aligned: .center).marginTop(15).width(100).height(100)
        tempInCity.pin(to: self).below(of: weatherImage).marginTop(20).horizontally(20).height(50)
        feelsLikeTempLabel.pin(to: self).below(of: tempInCity).marginTop(20).horizontally(20).height(50)
        tempWater.pin(to: self).below(of: feelsLikeTempLabel).marginTop(20).horizontally(20).height(50)
        windSpeed.pin(to: self).below(of: tempWater).marginTop(20).horizontally(20).height(50)
        
    }
}
