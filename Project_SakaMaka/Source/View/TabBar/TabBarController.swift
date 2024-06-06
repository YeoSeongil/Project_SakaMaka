//
//  TabBarController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/20/24.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarUI()
        setTabBarController()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - SetUp TabBarController
    private func setTabBarUI() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = .Turquoise
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.addShadow(alpha: 0.1, y: -4, blur: 5)
    }
    
    private func setTabBarController() {
        // Todo 나머지 VC 구현 후 추가
        let feedViewController = setNavigationController(title: "피드", unselectedImage: UIImage(named:  "tapbar_feed"), rootViewController: FeedViewController())
        let mypageViewController = setNavigationController(title: "내정보", unselectedImage: UIImage(systemName: "squareshape.split.2x2"), rootViewController: MypageViewController())
        
        
        viewControllers = [feedViewController, mypageViewController]
    }
}

// MARK: - Method
extension TabBarController {
    private func setNavigationController(title: String, unselectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.title = title
        navigationController.tabBarItem.image = unselectedImage
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
}
