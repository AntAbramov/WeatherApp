//
//  MainTableViewCell.swift
//  WeatherApp
//
//  Created by Anton Abramov on 07.02.2023.
//
// swiftlint:disable trailing_whitespace

import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - Images
    var rainImage: UIImage? {
        var image = UIImage(systemName: "cloud.rain.fill")
        return image
    }
    
    var cloudImage: UIImage? {
        var image = UIImage(systemName: "sun.max.fill")
        return image
    }
    
    var sunImage: UIImage? {
        var image = UIImage(systemName: "cloud.fill")
        return image
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(with model: Weather) {
        //fetch
        if let sun = sunImage {
            self.weatherImageView.image = sun
        }
        
        
        
    }
    
    //MARK: - Registration
    static let identifire = "MainTableViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "MainTableViewCell", bundle: nil)
    }
    
    
    
}
