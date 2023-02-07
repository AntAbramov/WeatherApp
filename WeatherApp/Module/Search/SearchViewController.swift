import UIKit

protocol SearchViewProtocol: AnyObject {
}

class SearchViewController: UIViewController, SearchViewProtocol {
    var searchPresenter: SearchPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }

}
