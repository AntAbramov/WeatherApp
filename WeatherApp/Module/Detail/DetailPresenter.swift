import UIKit

protocol DetailPresenterProtocol: AnyObject {
}

class DetailPresenterImplementation: DetailPresenterProtocol {
    weak var detailView: DetailViewProtocol!
}
