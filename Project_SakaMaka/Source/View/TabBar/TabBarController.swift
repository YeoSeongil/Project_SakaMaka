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
        let homeVC = setNavigationController(title: "홈", unselectedImage: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"), rootViewController: HomeViewController())
        let testVC2 = setNavigationController(title: "홈2", unselectedImage: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "home.fill"), rootViewController: Test2ViewController())
        
        viewControllers = [homeVC, testVC2]
    }
}

// MARK: - Method
extension TabBarController {
    private func setNavigationController(title: String, unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.title = title
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
}
