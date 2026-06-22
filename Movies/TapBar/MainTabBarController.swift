import UIKit

class MainTabBarController: UITabBarController {
    
    private let customTabBar = CustomTabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupCustomTabBar()
    }
    private func setupTabs() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        let watchVC = WatchListViewController(nibName: "WatchListViewController", bundle: nil)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let watchNav = UINavigationController(rootViewController: watchVC)
        
        viewControllers = [homeNav, searchNav, watchNav]
    }
    private func setupCustomTabBar() {
        view.addSubview(customTabBar)
        
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        customTabBar.delegate = self
    }
}

// MARK: - CustomTabBarDelegate
extension MainTabBarController: CustomTabBarDelegate {
    func didSelectTab(index: Int) {
        selectedIndex = index
        if let nav = viewControllers?[index] as? UINavigationController {
            nav.popToRootViewController(animated: false)
        }
    }

    func switchToTab(_ index: Int) {
        didSelectTab(index: index)
        customTabBar.select(index: index)
    }
}
