import UIKit

class MainTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configureCell(with model: Weather?) {
        guard let model = model else { return }
        
        if let iconString = model.weather?.first?.icon {
            if let image = UIImage(named: iconString) {
                self.weatherImageView.image = image
            }
        }
        
        if let description = model.weather?.first?.description {
            self.descriptionLabel.text = description
        }
        
        self.cityNameLabel.text = model.name
        
        if let temp = model.main?.temp {
            self.temperatureLabel.text = "\(Int(temp))℃"
        }
        
    }
    
    // MARK: - Registration
    static let identifire = "MainTableViewCell"
    
    static func nib() -> UINib? {
        UINib(nibName: "MainTableViewCell", bundle: nil)
    }
}
