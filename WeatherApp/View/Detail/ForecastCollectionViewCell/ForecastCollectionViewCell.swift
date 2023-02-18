//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Anton Abramov on 18.02.2023.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Registration
    static let identifire = "ForecastCollectionViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
    }

}
