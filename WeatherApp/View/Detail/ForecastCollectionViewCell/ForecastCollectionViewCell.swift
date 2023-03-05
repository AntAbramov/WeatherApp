//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Anton Abramov on 18.02.2023.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    func configure() {
        self.backView.backgroundColor = .tertiarySystemBackground
        self.backView.layer.cornerRadius = 10
    }
    
    static let identifire = "ForecastCollectionViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
    }

}
