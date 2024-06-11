//
//  SceneDelegate.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            window = UIWindow(windowScene: windowScene)
            
            let splashViewController = SplashViewController()
            window?.rootViewController = splashViewController
            window?.makeKeyAndVisible()
            
            // 2초 후에 사용자 인증 상태를 확인하여 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.checkAuthentication()
            }
        }
    
    private func checkAuthentication() {
        let newRootViewController: UIViewController
        
        if Auth.auth().currentUser != nil {
            // 사용자 인증이 되어 있을 경우
            let tabBarController = TabBarController()
            let navigationController = UINavigationController()
            navigationController.navigationBar.isHidden = true
            navigationController.viewControllers = [tabBarController]
            newRootViewController = navigationController
        } else {
            // 사용자 인증이 되어 있지 않을 경우
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.navigationBar.isHidden = true
            newRootViewController = navigationController
        }
        
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = newRootViewController
        }, completion: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

