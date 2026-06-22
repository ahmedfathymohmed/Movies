//
//  AppCoordinator.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 19/01/2026.
//

import Foundation
import UIKit


class AppCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Start
    
    func start() {
        showMain()
    }
    
    // MARK: - Main Flow
    
    func showMain() {
        let tabBar = MainTabBarController()
        navigationController.setViewControllers([tabBar], animated: false)
    }
    
    // MARK: - Navigation
    
    func goToDetails(movieId: Int) {
        
        print(" Navigating with movie ID: \(movieId)")
        
        let vc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        let vm = DetailsViewModel(movieId: movieId)
        
        vc.viewModel = vm
        vc.coordinator = self
        
       
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        guard let tabBar = navigationController.topViewController as? UITabBarController,
              let nav = tabBar.selectedViewController as? UINavigationController else {
            navigationController.popViewController(animated: true)
            return
        }
        
        nav.popViewController(animated: true)
    }
}
