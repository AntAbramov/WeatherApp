import UIKit

protocol MainViewProtocol: AnyObject {
    
}

class MainViewController: UIViewController, MainViewProtocol {
    
    var mainPresenter: MainPresenterProtocol!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
