import UIKit

protocol MainPresenterProtocol: AnyObject {
    
}

class MainPresenter: MainPresenterProtocol {
    weak var mainView: MainViewProtocol!
    var router: RouterProtocol?
    
    init(mainView: MainViewProtocol, router: RouterProtocol) {
        self.mainView = mainView
        self.router = router
    }
}
