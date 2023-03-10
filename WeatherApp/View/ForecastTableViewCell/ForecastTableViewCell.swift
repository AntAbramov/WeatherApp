import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    
    func configure(with model: DailyForecast?) {
        self.backgroundColor = .tertiarySystemBackground
        self.layer.cornerRadius = 10
        
        if let name = model?.iconName {
            if let image = UIImage(named: name) {
                self.iconImageView.image = image
            }
        }
        
        if let dayTemp = model?.dayTemp {
            self.dayTempLabel.text = dayTemp
        }
        
        if let nightTemp = model?.nightTemp {
            self.nightTempLabel.text = nightTemp
        }
        
        if let weekDay = model?.weekDay {
            self.weekDayLabel.text = weekDay
        }
        
    }
    
    // MARK: - Registration
    static let identifire = "ForecastTableViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "ForecastTableViewCell", bundle: nil)
    }
    
}
