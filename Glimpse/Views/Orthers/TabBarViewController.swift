//
//  TabBarViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        let vc1 = MapViewController()
        let vc2 = FriendsViewController()
        let vc3 = AccountViewController()
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.2"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "You", image: UIImage(systemName: "person"), tag: 3)
        
        setViewControllers([nav1, nav2, nav3], animated: true)
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        
        tabBar.layer.masksToBounds = false
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        tabBar.layer.shadowOpacity = 0.15
        tabBar.layer.shadowRadius = 10
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(hex: "F1F1F1").cgColor
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let newTabBarHeight: CGFloat = 70
        let newTabBarWidth: CGFloat = 300
        let marginBottom: CGFloat = 20
        
        let tabBarX = (view.frame.width - newTabBarWidth) / 2
        
        let tabBarY = view.frame.height - newTabBarHeight - marginBottom
        
        tabBar.frame = CGRect(x: tabBarX, y: tabBarY, width: newTabBarWidth, height: newTabBarHeight)
        
        tabBar.layer.masksToBounds = false
    }
    
}
