import UIKit

struct HourlyForecastInfo {
    let time: String
    let icon: String
    let temp: String
}

class DetailViewController: UIViewController {
    
    var weatherModel: Weather?
    var forecastModel: Forecast? {
        didSet {
            fillHourlyForecastInfoDataSource(with: forecastModel)
        }
    }
    
    private var hourlyForecastInfoDataSource = [HourlyForecastInfo?]()
        
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDailyForecastTableView()
        configureHourlyForecastCollectionView()
        cunfigureNavigationController()
        
        cityNameLabel.text = weatherModel?.name
        
        if let currentTemp = weatherModel?.main?.temp {
            currentTemperatureLabel.text = "\(Int(currentTemp))℃"
        }
        
        if let description = weatherModel?.weather?.first?.description {
            self.descriptionLabel.text = description
        }
        
    }
    
    private func fillHourlyForecastInfoDataSource(with model: Forecast?) {
        guard let list = model?.list else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        list.forEach { element in
            var timeHour = String()
            var icon = String()
            var temp = String()
            
            if let dateStr = element.dtTxt {
                if let date = dateFormatter.date(from: dateStr) {
                    let hour = Calendar.current.component(.hour, from: date)
                    timeHour = "\(hour)"
                }
            }
            
            if let temperature = element.main?.temp {
                temp = "\(Int(temperature))℃"
            }
            
            if let imageName = element.weather?.first?.icon {
                icon = imageName
            }
            
            let hourlyForecastInfoElement = HourlyForecastInfo(time: timeHour, icon: icon, temp: temp)
            self.hourlyForecastInfoDataSource.append(hourlyForecastInfoElement)
        }
        
        
        
        
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyForecastCollectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifire, for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hourlyForecastInfoDataSource[indexPath.row])
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










// MARK: - DetailViewController Configuration
extension DetailViewController {
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
