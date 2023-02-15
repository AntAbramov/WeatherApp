import UIKit
import MapKit

class ResultViewController: UIViewController {
    let tableView = UITableView(frame: CGRect(), style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResultTableViewCell.nib(), forCellReuseIdentifier: ResultTableViewCell.identifire)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewSetConstraints()
    }
    
    //MARK: tableViewConstraints
    func tableViewSetConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

// MARK: - UITableViewDataSource
extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifire, for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //По нотифай передаем координаты выбранного города в mainVC
        let coordinate = Coordinate(lat: 10, lon: 11)
        NotificationCenter.default.post(name: .selectCity, object: coordinate)
        self.dismiss(animated: true)
    }
}
