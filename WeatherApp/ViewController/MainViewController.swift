import UIKit

class MainViewController: UIViewController {
    //MARK: UI
    let mainTableView = UITableView(frame: CGRect(), style: .insetGrouped)
    let searchController = UISearchController(searchResultsController: ResultViewController())
    let editButton = UIBarButtonItem()
    
    //MARK: Service
    let networkService = NetworkService()
    
    //TODO: fill array with relevant info
    private var weatherDataSource: [Weather] = [Weather]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    //TODO: fill with user defaults
    var cityCoordinates: [Coordinate] = [Coordinate]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureMainTableView()
        configureEditButton()
//        let generator = UISelectionFeedbackGenerator()
//        generator.selectionChanged()
        
        fillCityCoordinates()
        obtainAllWeather()
        print(weatherDataSource.count)
        
    }
    
    //При старте прило
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
    
    //для вновь добавленного города
    func obtainWeather(by coordinate: Coordinate) {
        if let url = UrlType.weather.configureUrl(with: coordinate) {
            networkService.obtainData(url: url) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.weatherDataSource.append(weather)
                case .failure(let error):
                    //Cделать класс создающий алерты и здесь делать ему нотифай передавая туда описание ошибки (позможность перезапустить приложение)
                    print(error)
                }
            }
        }
    }
    
    
    
    //FIXME: Delete func
    func fillCityCoordinates() {
        for _ in 0...4 {
            cityCoordinates.append(Coordinate(lat: 10, lon: 10))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setMainTableViewConstraints()
    }
    
    func configureEditButton() {
        editButton.style = .plain
        editButton.action = #selector(editPressed)
        editButton.title = "Edit"
        editButton.target = self
        navigationItem.rightBarButtonItem = editButton
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
    
    func configureNavBar() {
        title = "Weather"
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
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
        cell.configureCell(with: weatherDataSource[indexPath.row])
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
