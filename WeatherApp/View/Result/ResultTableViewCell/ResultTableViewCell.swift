//
//  ResultTableViewCell.swift
//  WeatherApp
//
//  Created by Anton Abramov on 09.02.2023.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with cityName: String) {
        cityNameLabel.text = cityName
    }
    
    static func nib() -> UINib? {
        UINib(nibName: "ResultTableViewCell", bundle: nil)
    }
    
    static let identifire = "ResultTableViewCell"
}
