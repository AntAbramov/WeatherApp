import UIKit

class MainViewController: UIViewController {
    
    let mainTableView = UITableView(frame: CGRect(), style: .insetGrouped)
    let searchController = UISearchController(searchResultsController: ResultViewController())
    
    //TODO: fill array with relevant info
    var weatherDataSource: [Weather] = {
        var array = [Weather]()
        for _ in 0...9 {
            array.append(Weather())
        }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.hidesSearchBarWhenScrolling = false
        
        configureMainTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setMainTableViewConstraints()
    }
    
    func configureMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(MainTableViewCell.nib(),
                               forCellReuseIdentifier: MainTableViewCell.identifire)
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
