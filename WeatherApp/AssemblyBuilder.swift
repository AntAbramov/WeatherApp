import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(model: Weather, router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(mainView: view, router: router)
        view.mainPresenter = presenter
        return view
    }
    
    func createDetailModule(model: Weather, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        return view
    }
    
}
