import UIKit

class DetailViewController: UIViewController {
    
    var model: Weather?
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        navigationController?.navigationBar.tintColor = .white
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.register(ForecastCollectionViewCell.nib(),
                                              forCellWithReuseIdentifier: ForecastCollectionViewCell.identifire)
        hourlyForecastCollectionView.isScrollEnabled = true
        
    }
    
}

extension DetailViewController: UICollectionViewDelegate {
    
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyForecastCollectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifire, for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
