//
//  MainTabBarController.swift
//  Poddler
//
//  Created by Pohle, Sven on 7/11/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .purple
        
        setupViewControllers()
    }
    
    //MARK: - Setup Functions
    fileprivate func setupViewControllers() {
        viewControllers = [
            generateNavigationController(viewController: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(viewController: ViewController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(viewController: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    //MARK: - Helper Functions
    fileprivate func generateNavigationController(viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        
        viewController.navigationItem.title = title
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
}
