import UIKit

protocol MainViewProtocol: AnyObject {
}

class MainViewController: UIViewController, MainViewProtocol {
    
    var mainPresenter: MainPresenterProtocol!
    
    let mainTableView = UITableView(frame: CGRect(), style: .insetGrouped)
    let searchController = UISearchController(searchResultsController: SearchViewController())
    
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
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifire, for: indexPath)
                as? MainTableViewCell else { return UITableViewCell() }
        cell.configureCell(with: Weather())
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
}
