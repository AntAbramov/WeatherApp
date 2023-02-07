import UIKit

protocol DetailViewProtocol: AnyObject {
}

class DetailViewController: UIViewController, DetailViewProtocol {
    var detailPresenter: DetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
