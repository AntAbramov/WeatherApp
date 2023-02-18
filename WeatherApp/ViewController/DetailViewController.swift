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
        navigationController?.navigationBar.tintColor = .white
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.register(ForecastCollectionViewCell.nib(),
                                              forCellWithReuseIdentifier: ForecastCollectionViewCell.identifire)
        hourlyForecastCollectionView.showsHorizontalScrollIndicator = false
        
        dailyForecastTableView.delegate = self
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.register(ForecastTableViewCell.nib(), forCellReuseIdentifier: ForecastTableViewCell.identifire)
        
        dailyForecastTableView.showsVerticalScrollIndicator = false
        
        // MARK: - tableHeaderView
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        label.font = label.font.withSize(20)
        label.text = "5 Days Forecast:"
        label.textAlignment = .center
        dailyForecastTableView.tableHeaderView = label
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyForecastCollectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifire, for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure()
        return cell
    }
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dailyForecastTableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifire, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
}
