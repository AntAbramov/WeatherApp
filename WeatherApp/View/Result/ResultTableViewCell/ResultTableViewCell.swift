import UIKit
import MapKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var searchData: MKLocalSearchCompletion? {
        didSet {
            guard let cityData = searchData else {
                return
            }
            cityNameLabel.text = cityData.title
        }
    }

    func configure(data: MKLocalSearchCompletion) {
        searchData = data
    }
    
    //MARK: Registration
    static func nib() -> UINib? {
        UINib(nibName: "ResultTableViewCell", bundle: nil)
    }
    
    static let identifire = "ResultTableViewCell"
}
