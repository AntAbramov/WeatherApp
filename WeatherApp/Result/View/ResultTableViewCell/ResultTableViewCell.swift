//
//  ResultTableViewCell.swift
//  WeatherApp
//
//  Created by Anton Abramov on 09.02.2023.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static func nib() -> UINib? {
        UINib(nibName: "ResultTableViewCell", bundle: nil)
    }
    
    static let identifire = "ResultTableViewCell"
}
