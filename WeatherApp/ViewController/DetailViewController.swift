import UIKit

class DetailViewController: UIViewController {
    
    var model: Weather? {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDailyForecastTableView()
        configureHourlyForecastCollectionView()
        cunfigureNavigationController()
    }
    
    // MARK: - Configuration
    private func configureHourlyForecastCollectionView() {
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.register(ForecastCollectionViewCell.nib(),
                                              forCellWithReuseIdentifier: ForecastCollectionViewCell.identifire)
        hourlyForecastCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureDailyForecastTableView() {
        dailyForecastTableView.delegate = self
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.register(ForecastTableViewCell.nib(), forCellReuseIdentifier: ForecastTableViewCell.identifire)
        dailyForecastTableView.sectionHeaderTopPadding = 0
        dailyForecastTableView.showsVerticalScrollIndicator = false
    }
    
    private func cunfigureNavigationController() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 7
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 5 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dailyForecastTableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifire, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        cell.configure()
        cell.selectionStyle = .none
        return cell
    }
}
