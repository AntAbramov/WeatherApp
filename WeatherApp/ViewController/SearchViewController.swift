import UIKit
import MapKit

class SearchViewController: UIViewController {
    let tableView = UITableView()
    
    private var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    private var searchResults: [MKLocalSearchCompletion] = [MKLocalSearchCompletion]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchText = "" {
        didSet {
            searchCompleter.queryFragment = searchText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        searchCompleter.delegate = self
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewSetConstraints()
    }
    
    private func cityDidSelected(_ selected: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: selected)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error != nil {
                print(APIError.localRequestFailed)
            }
            let coordinate = response?.mapItems.first?.placemark.coordinate
            NotificationCenter.default.post(name: .selectCity, object: coordinate)
            self.dismiss(animated: true, completion: nil)
        }
    }

    //MARK: - Configuration
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResultTableViewCell.nib(), forCellReuseIdentifier: ResultTableViewCell.identifire)
    }
    
    //MARK: - Constraints
    func tableViewSetConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifire, for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(data: searchResults[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityDidSelected(searchResults[indexPath.row])
    }
}

//MARK: - SearchCompleterDelegate
extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completer.resultTypes = .address
        searchResults = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(APIError.localRequestFailed)
    }
}
