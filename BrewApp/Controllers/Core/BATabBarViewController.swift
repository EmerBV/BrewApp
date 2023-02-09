//
//  BATabBarViewController.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import UIKit

class BATabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    

    private func setUpTabs() {
        let mainVC = BAMainViewController()
        let searchVC = BASearchViewController()
        
        mainVC.navigationItem.largeTitleDisplayMode = .automatic
        searchVC.navigationItem.largeTitleDisplayMode = .automatic
       
        let nav1 = UINavigationController(rootViewController: mainVC)
        let nav2 = UINavigationController(rootViewController: searchVC)
       
        nav1.tabBarItem = UITabBarItem(title: "Beers",
                                       image: UIImage(systemName: "house"),
                                       tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search",
                                       image: UIImage(systemName: "magnifyingglass"),
                                       tag: 2)
        
        tabBar.tintColor = UIColor(red: 0.80, green: 0.64, blue: 0.00, alpha: 1.00)
    
        for nav in [nav1, nav2] {
            nav.navigationBar.prefersLargeTitles = true
            nav.navigationBar.tintColor = UIColor(red: 0.80, green: 0.64, blue: 0.00, alpha: 1.00)
        }

        setViewControllers(
            [nav1, nav2],
            animated: true
        )
    }

}

