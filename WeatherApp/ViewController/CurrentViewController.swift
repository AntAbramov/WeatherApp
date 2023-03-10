//
//  NewDetailViewController.swift
//  WeatherApp
//
//  Created by Anton Abramov on 10.03.2023.
//

import UIKit

class CurrentViewController: UIViewController {
    
    var currentIndex: Int = 0
    var totalPageCount: Int = 0
    
    var forecastModel: Forecast? {
        didSet {
            fillHourlyForecastData(with: forecastModel)
            fillDailyForecastData(with: forecastModel)
        }
    }
    
    //MARK: Models for Cells
    private var hourlyForecastData = [HourlyForecast?]()
    private var dailyForecastData = [DailyForecast?]()
        
    //MARK: UI
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDailyForecastTableView()
        configureHourlyForecastCollectionView()
        cunfigureNavigationController()
        setMainLabelsText(with: forecastModel)
    }
    
    private func setMainLabelsText(with model: Forecast?) {
        self.cityNameLabel.text = model?.city?.name
        self.currentTemperatureLabel.text = "\(Int())℃"
        self.descriptionLabel.text = model?.list?.first?.weather?.first?.description
    }
    
    // MARK: - Relevant Model for CollectionViewCells
    private func fillHourlyForecastData(with model: Forecast?) {
        guard let list = model?.list else { return }
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
            
            let hourlyForecastInfoElement = HourlyForecast(time: timeHour, icon: icon, temp: temp)
            self.hourlyForecastData.append(hourlyForecastInfoElement)
        }
    }
    
    // MARK: - Relevant model for TableViewCell
    private func fillDailyForecastData(with model: Forecast?) {
        guard let list = model?.list else { return }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let weekDict = [1 : "Mon", 2 : "Tue", 3 : "Wed", 4 : "Thu", 5 : "Fri", 6 : "Set", 7 : "Sun"]
    
        var dayTemp = String()
        var nightTemp = String()
        var iconName = String()
        var weekDay = String()
        
        var startDay = Int()
        guard let dateStr = model?.list?.first?.dtTxt else { return }
        if let date = dateFormatter.date(from: dateStr) {
            startDay = Calendar.current.component(.weekday, from: date)
        }
        
        list.forEach { element in
            guard let dateStr = element.dtTxt else { return }
            guard let date = dateFormatter.date(from: dateStr) else { return }
            let currentWeekDay = Calendar.current.component(.weekday, from: date)
            guard currentWeekDay != startDay else { return }
            
            let dayTime = Calendar.current.component(.hour, from: date)
            switch dayTime {
            case 0:
                guard let currentNightTemp = element.main?.temp else { return }
                nightTemp = "Night: \(Int(currentNightTemp))℃"
                
                let day = Calendar.current.component(.weekday, from: date)
                if let weekDayStr = weekDict[day] {
                    weekDay = weekDayStr
                }
            case 12:
                guard let currentDayTemp = element.main?.temp else { return }
                dayTemp = "Day: \(Int(currentDayTemp))℃"
                if let currentIcon = element.weather?.first?.icon {
                    iconName = currentIcon
                }
            case 21:
                let currentModel = DailyForecast(dayTemp: dayTemp, nightTemp: nightTemp, iconName: iconName, weekDay: weekDay)
                self.dailyForecastData.append(currentModel)
            default: break
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension CurrentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyForecastCollectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifire, for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hourlyForecastData[indexPath.row])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CurrentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
}

// MARK: - UITableViewDelegate
extension CurrentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 7
    }
}

// MARK: - UITableViewDataSource
extension CurrentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { dailyForecastData.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dailyForecastTableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifire, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        cell.configure(with: dailyForecastData[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - DetailViewController Configuration
extension CurrentViewController {
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
        
    }
    
}
