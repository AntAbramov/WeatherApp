import UIKit
import MapKit

final class MainViewController: UIViewController {
    
    // MARK: UI
    private let mainTableView = UITableView(frame: CGRect(), style: .insetGrouped)
    private let resultVC = ResultViewController()
    private let searchController = UISearchController(searchResultsController: ResultViewController())
    private let editButton = UIBarButtonItem()
    
    //MARK: Services
    private let networkService = NetworkService()
    
    //MARK: Binding
    private var weatherDataSourceIsAvailable = false
    private var forecastDataSourceIsAvailable = false
    
    //MARK: DataSource
    private var forecastDataSource: [Forecast?]? = [Forecast]()
    private var weatherDataSource: [Weather?]? = [Weather?]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    private var cityCoordinates: [Coordinate?]? = [Coordinate?]() {
        didSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.cityCoordinates),
                                      forKey: UserDefaultsKeys.cities)
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCityCoordinates()
        configureNavigationItem()
        configureMainTableView()
        configureEditButton()
        createNotificationCenter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setMainTableViewConstraints()
    }
    
    //MARK: On app start fetching Coordinates from UserDefaults
    private func fetchCityCoordinates() {
        guard let cityLists = UserDefaults.standard.value(forKey: UserDefaultsKeys.cities) as? Data else { return }
        if let cityList = try? PropertyListDecoder().decode([Coordinate].self, from: cityLists) {
            cityCoordinates = cityList
            DispatchQueue.global().async {
                self.obtainAllWeather()
                self.obtainAllForecast()
            }
        }
    }
    
    //MARK: On app start fetching Weather
    private func obtainAllWeather() {
        var localWeatherArray = [Weather]()
        let dispatchGroup = DispatchGroup()
        
        cityCoordinates?.forEach { coordinate in
            guard let weatherUrl = UrlType.weather.configureUrl(with: coordinate) else { return }
            dispatchGroup.enter()
            networkService.obtainWeather(url: weatherUrl) { (result) in
                switch result {
                case .success(let weather):
                    localWeatherArray.append(weather)
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.weatherDataSource = localWeatherArray
            self.weatherDataSourceIsAvailable = true
        }
    }
    
    //MARK: On app start fetching Forecast
    private func obtainAllForecast() {
        var localForecastArray = [Forecast]()
        let dispatchGroup = DispatchGroup()
        
        cityCoordinates?.forEach { coordinate in
            guard let forecastrUrl = UrlType.forecast.configureUrl(with: coordinate) else { return }
            dispatchGroup.enter()
            networkService.obtainForecast(url: forecastrUrl) { (result) in
                switch result {
                case .success(let forecast):
                    localForecastArray.append(forecast)
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.forecastDataSource = localForecastArray
            self.forecastDataSourceIsAvailable = true
        }
    }
    
    //MARK: Target fetching
    private func obtainWeather(by coordinate: Coordinate) {
        if let url = UrlType.weather.configureUrl(with: coordinate) {
            networkService.obtainWeather(url: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.weatherDataSource?.append(weather)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func obtainForecast(by coordinate: Coordinate) {
        if let url = UrlType.forecast.configureUrl(with: coordinate) {
            networkService.obtainForecast(url: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let forecast):
                    self.forecastDataSource?.append(forecast)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: - NotificationCenter
    private func createNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCity), name: .selectCity, object: nil)
    }
    
    @objc private func selectedCity(notification: NSNotification) {
        guard let cityCoordinate = notification.object as? CLLocationCoordinate2D else { return }
        let coordinate = Coordinate(lat: cityCoordinate.latitude, lon: cityCoordinate.longitude)
        cityCoordinates?.append(coordinate)
        obtainWeather(by: coordinate)
        obtainForecast(by: coordinate)
    }
    
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weatherDataSourceIsAvailable {
            guard let elementsCount = weatherDataSource?.count else { return 0 }
            return elementsCount
        } else {
            guard let coordinatesCount = cityCoordinates?.count else { return 0 }
            return coordinatesCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifire, for: indexPath)
                as? MainTableViewCell else { return UITableViewCell() }
        if weatherDataSourceIsAvailable {
            cell.configureCell(with: weatherDataSource?[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherDataSource?.remove(at: indexPath.row)
            cityCoordinates?.remove(at: indexPath.row)
            forecastDataSource?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removedWeatherElement = weatherDataSource?.remove(at: sourceIndexPath.row)
        weatherDataSource?.insert(removedWeatherElement, at: destinationIndexPath.row)
        
        let removedCoordinateElement = cityCoordinates?.remove(at: sourceIndexPath.row)
        cityCoordinates?.insert(removedCoordinateElement, at: destinationIndexPath.row)
        
        let removedForecastElement = forecastDataSource?.remove(at: sourceIndexPath.row)
        forecastDataSource?.insert(removedForecastElement, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

//MARK: - UITableV§iewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if forecastDataSourceIsAvailable && weatherDataSourceIsAvailable {
            if let currentForecastModel = forecastDataSource?[indexPath.row], let currentWeatherModel = weatherDataSource?[indexPath.row] {
                let detailVC = DetailViewController()
                detailVC.forecastModel = currentForecastModel
                detailVC.weatherModel = currentWeatherModel
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}

//MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let destinationVC = searchController.searchResultsController as? ResultViewController
        destinationVC?.searchText = text
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
    }
}

//MARK: - MainViewController configuration
extension MainViewController {
    private func configureEditButton() {
        editButton.style = .plain
        editButton.action = #selector(editPressed)
        editButton.title = "Edit"
        editButton.target = self
        editButton.tintColor = .white
    }
    
    @objc private func editPressed() {
        mainTableView.setEditing(!mainTableView.isEditing, animated: true)
        editButton.title = mainTableView.isEditing ? "Done" : "Edit"
    }
    
    private func configureMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(MainTableViewCell.nib(), forCellReuseIdentifier: MainTableViewCell.identifire)
    }
    
    private func configureNavigationItem() {
        title = "Weather"
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .white
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = editButton
    }
    
    //MARK: Constraints
    private func setMainTableViewConstraints() {
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mainTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
