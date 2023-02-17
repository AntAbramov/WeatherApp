import UIKit
import MapKit

final class MainViewController: UIViewController {
    
    private let mainTableView = UITableView(frame: CGRect(), style: .insetGrouped)
    private let resultVC = ResultViewController()
    private let searchController = UISearchController(searchResultsController: ResultViewController())
    private let editButton = UIBarButtonItem()
    private let networkService = NetworkService()
    
    private var weatherDataSource: [Weather] = [Weather]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    private var cityCoordinates: [Coordinate] = [Coordinate]() {
        didSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.cityCoordinates),
                                      forKey: UserDefaultsKeys.cities)
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureMainTableView()
        configureEditButton()
        obtainAllWeather()
        createNotificationCenter()
        fetchCityCoordinates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setMainTableViewConstraints()
    }
    
    func fetchCityCoordinates() {
        guard let cityLists = UserDefaults.standard.value(forKey: UserDefaultsKeys.cities) as? Data else { return }
        if let cityList = try? PropertyListDecoder().decode([Coordinate].self, from: cityLists) {
            cityCoordinates = cityList
            DispatchQueue.global().async {
                self.obtainAllWeather()
            }
        }
    }
    
    //MARK: On app start fetching (DispatchGroup)
    func obtainAllWeather() {
        var localWeatherArray = [Weather]()
        let dispatchGroup = DispatchGroup()
        
        cityCoordinates.forEach { coordinate in
            guard let url = UrlType.weather.configureUrl(with: coordinate) else { return }
            dispatchGroup.enter()
            networkService.obtainData(url: url) { (result) in
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
        }
        
    }
    
    func obtainWeather(by coordinate: Coordinate) {
        if let url = UrlType.weather.configureUrl(with: coordinate) {
            networkService.obtainData(url: url) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.weatherDataSource.append(weather)
                case .failure(let error):
                    //TODO: Cделать класс создающий алерты
                    //и здесь делать ему нотифай передавая туда описание ошибки (позможность перезапустить приложение)
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
        cityCoordinates.append(coordinate)
        obtainWeather(by: coordinate)
    }
    
    // MARK: - Configuration
    func configureEditButton() {
        editButton.style = .plain
        editButton.action = #selector(editPressed)
        editButton.title = "Edit"
        editButton.target = self
        editButton.tintColor = .white
    }
    
    @objc func editPressed() {
        mainTableView.setEditing(!mainTableView.isEditing, animated: true)
        editButton.title = mainTableView.isEditing ? "Done" : "Edit"
    }
    
    func configureMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(MainTableViewCell.nib(), forCellReuseIdentifier: MainTableViewCell.identifire)
    }
    
    func configureNavigationItem() {
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
    func setMainTableViewConstraints() {
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mainTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
 
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifire, for: indexPath)
                as? MainTableViewCell else { return UITableViewCell() }
        if !weatherDataSource.isEmpty {
            cell.configureCell(with: weatherDataSource[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherDataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removedWeatherElement = weatherDataSource.remove(at: sourceIndexPath.row)
        weatherDataSource.insert(removedWeatherElement, at: destinationIndexPath.row)
        
        let removedCoordinateElement = cityCoordinates.remove(at: sourceIndexPath.row)
        cityCoordinates.insert(removedCoordinateElement, at: destinationIndexPath.row)
    }
    
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentModel = weatherDataSource[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.model = currentModel
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}

// MARK: - UISearchResultsUpdating
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
