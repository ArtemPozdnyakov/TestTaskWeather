//
//  CityViewCell.swift
//  TestTaskWeather
//
//  Created by Artem Pozdnyakov on 10/28/20.
//

import PinLayout
import UIKit

class CityViewCell: UICollectionViewCell {
    
    
    internal var nameCity: UILabel = {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .black
        $0.backgroundColor = #colorLiteral(red: 0.5748289227, green: 0.5990194678, blue: 1, alpha: 1)
        return $0
    }(UILabel())
    
    internal var tempInCity: UILabel = {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .black
        $0.backgroundColor = #colorLiteral(red: 0.5748289227, green: 0.5990194678, blue: 1, alpha: 1)
        
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    internal var weatherImage: UIImageView = {
        $0.image = UIImage(systemName: "cloud.bolt.rain.fill")
        $0.tintColor = #colorLiteral(red: 0.8279205561, green: 0.7523292899, blue: 1, alpha: 1)
        $0.backgroundColor = #colorLiteral(red: 0.5748289227, green: 0.5990194678, blue: 1, alpha: 1)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    internal var greayView: UIView = {
        $0.backgroundColor = #colorLiteral(red: 0.8584951162, green: 0.8533921838, blue: 0.8624178767, alpha: 1)
        return $0
    }(UIView())
    
    //MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        initView()
    }
    
    
    func initView() {
        backgroundColor = #colorLiteral(red: 0.5748289227, green: 0.5990194678, blue: 1, alpha: 1)
        
        let width = self.frame.width / 2
        
        greayView.pin(to: self).vCenter().horizontally(32).height(30)
        
        nameCity.pin(to: self).vCenter().left(10).height(50).width(width)
        tempInCity.pin(to: self).after(of: nameCity, aligned: .center).margin(2).width(width / 2).height(50)
        weatherImage.pin(to: self).after(of: tempInCity, aligned: .center).margin(2).width(width / 4).height(width / 4)
        
    }
}
