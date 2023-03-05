import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    func configure() {
        self.backgroundColor = .tertiarySystemBackground
        self.layer.cornerRadius = 10
        
    }
    
    static let identifire = "ForecastTableViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "ForecastTableViewCell", bundle: nil)
    }
    
}
