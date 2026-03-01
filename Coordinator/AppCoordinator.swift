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
    
    func start() {
        showMain()
    }
    func showMain() {
        let vc = HomeViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
    func goToDetails(movieId: Int) {
        print("Navigating with movie ID: \(movieId)")
        let vc = DetailsViewController()
        let vm = DetailsViewModel(movieId: movieId)
        
        vc.viewModel = vm
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
}
