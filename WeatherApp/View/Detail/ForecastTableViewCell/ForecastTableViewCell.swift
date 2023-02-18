import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    
    static let identifire = "ForecastTableViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "ForecastTableViewCell", bundle: nil)
    }
    
}
