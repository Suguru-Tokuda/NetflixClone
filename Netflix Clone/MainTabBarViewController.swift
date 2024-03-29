//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Suguru on 10/19/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = CustomNavigationController(rootViewController: HomeViewController())
        let vc2 = CustomNavigationController(rootViewController: UpcomingViewController())
        let vc3 = CustomNavigationController(rootViewController: SearchViewController())
        let vc4 = CustomNavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "Coming"
        vc3.tabBarItem.title = "Search"
        vc4.tabBarItem.title = "Downloads"
        
        tabBar.tintColor = .label

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}
