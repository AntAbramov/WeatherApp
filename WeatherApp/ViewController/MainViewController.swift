import UIKit

final class MainViewController: UIViewController {
    //MARK: UI
    private let mainTableView = UITableView(frame: CGRect(), style: .insetGrouped)
    private let resultVC = ResultViewController()
    private let searchController = UISearchController(searchResultsController: ResultViewController())
    private let editButton = UIBarButtonItem()
    
    
    //MARK: Service
    private let networkService = NetworkService()
    
    //MARK: DataSource
    private var weatherDataSource: [Weather] = [Weather]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    //TODO: fill with user defaults
    private var cityCoordinates: [Coordinate] = [Coordinate]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureMainTableView()
        configureEditButton()
        fillCityCoordinates()
        obtainAllWeather()
        createNotificationCenter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setMainTableViewConstraints()
    }
    
    //MARK: App start fetch (DispatchGroup)
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
    
    //MARK: New added city
    func obtainWeather(by coordinate: Coordinate) {
        if let url = UrlType.weather.configureUrl(with: coordinate) {
            networkService.obtainData(url: url) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.weatherDataSource.append(weather)
                case .failure(let error):
                    //TODO: Cделать класс создающий алерты и здесь делать ему нотифай передавая туда описание ошибки (позможность перезапустить приложение)
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
        guard let coordinate = notification.object as? Coordinate else { return }
        print(coordinate)
    }
    
    //FIXME: temp func
    func fillCityCoordinates() {
        cityCoordinates.append(Coordinate(lat: 25.276987, lon: 55.296249))
        cityCoordinates.append(Coordinate(lat: 40.416775, lon: -3.70379))
        cityCoordinates.append(Coordinate(lat: 55.75866, lon: 37.61929))
        cityCoordinates.append(Coordinate(lat: 41.88929, lon: 12.49355))
    }
 
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityCoordinates.count
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
        let removedElement = weatherDataSource.remove(at: sourceIndexPath.row)
        weatherDataSource.insert(removedElement, at: destinationIndexPath.row)
        //save array to persistent storage to keep new order if app deleted (user defaults)
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

//MARK: - Configure View
extension MainViewController {
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
        mainTableView.register(MainTableViewCell.nib(),
                               forCellReuseIdentifier: MainTableViewCell.identifire)
    }
    
    func configureNavigationItem() {
        title = "Weather"
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .white
        searchController.searchResultsUpdater = self
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = editButton
    }
    
    func setMainTableViewConstraints() {
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mainTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let destinationVC = searchController.searchResultsController as? ResultViewController
        destinationVC?.searchText = text
    }
}
