import UIKit

class DetailViewController: UIViewController {
    
    var model: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        navigationController?.navigationBar.tintColor = .white
    }

}
