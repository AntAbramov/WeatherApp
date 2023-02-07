import UIKit

protocol MainPresenterProtocol: AnyObject {
}

class MainPresenterImplementation: MainPresenterProtocol {
    weak var mainView: MainViewProtocol!
}
