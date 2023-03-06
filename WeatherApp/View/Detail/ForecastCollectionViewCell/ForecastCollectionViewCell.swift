//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Anton Abramov on 18.02.2023.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    func configure(with model: HourlyForecastInfo?) {
        self.backView.backgroundColor = .tertiarySystemBackground
        self.backView.layer.cornerRadius = 10
        
        if let temp = model?.temp {
            temperatureLabel.text = temp
        }
        
        if let time = model?.time {
            timeLabel.text = time
        }
        
        if let iconStr = model?.icon {
            if let image = UIImage(named: iconStr) {
                self.iconImageView.image = image
            }
        }
        
    }
    
    //MARK: Registration
    static let identifire = "ForecastCollectionViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
    }

}
