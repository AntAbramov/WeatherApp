import UIKit

class PageViewController: UIPageViewController {
    
    private var detailViewControllerArray = [CurrentViewController]()
    var forecastDataSource = [Forecast?]()
    var firstIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        createAllDetailViewControllers()
        setupFirstPageView()
    }
    
    private func createAllDetailViewControllers() {
        var count = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        forecastDataSource.forEach { forecast in
            guard let vc = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as? CurrentViewController else {
                return
            }
            vc.totalPageCount = forecastDataSource.count
            vc.currentIndex = count
            vc.forecastModel = forecast
            detailViewControllerArray.append(vc)
            count += 1
        }
    }
    
    private func setupFirstPageView() {
        let firstViewController = detailViewControllerArray[firstIndex]
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }

}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let current = viewController as? CurrentViewController,
            let VCIndex = detailViewControllerArray.firstIndex(of: current) else {
                return nil
        }
        
        let previousIndex = VCIndex - 1

        guard previousIndex >= 0,
              detailViewControllerArray.count > previousIndex else {
            return nil
        }
        return detailViewControllerArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = viewController as? CurrentViewController,
            let viewControllerIndex = detailViewControllerArray.firstIndex(of: current) else {
                return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = detailViewControllerArray.count
        
        guard orderedViewControllersCount != nextIndex,
            orderedViewControllersCount > nextIndex else {
            return nil
        }
        return detailViewControllerArray[nextIndex]
    }
}
