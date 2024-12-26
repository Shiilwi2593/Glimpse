//
//  SceneDelegate.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 07/08/2024.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
        // Start with StartViewController
        let startViewController = StartViewController()
        window?.rootViewController = startViewController
        window?.makeKeyAndVisible()
        
        // Setup location manager
        locationManager.delegate = self
        
        // Show splash screen for 2 seconds then check auth
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.checkLocationAuthorization()
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Request permission and wait for callback
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // Already authorized, proceed
            animateAndProceedToApp()
        case .denied, .restricted:
            showAlertForLocationAccess()
        @unknown default:
            animateAndProceedToApp()
        }
    }
    
    private func animateAndProceedToApp() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.window?.rootViewController?.view.alpha = 0
        }, completion: { [weak self] _ in
            self?.proceedToApp()
            // Fade in the new view controller
            self?.window?.rootViewController?.view.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self?.window?.rootViewController?.view.alpha = 1
            }
        })
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            animateAndProceedToApp()
        case .denied, .restricted:
            showAlertForLocationAccess()
        case .notDetermined:
            break // Wait for user response
        @unknown default:
            animateAndProceedToApp()
        }
    }
    
    private func showAlertForLocationAccess() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "Vị trí bị hạn chế",
                message: "Bạn cần bật quyền truy cập vị trí để sử dụng ứng dụng này.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cài đặt", style: .default) { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            })
            
            alert.addAction(UIAlertAction(title: "Hủy", style: .cancel) { _ in
                self?.animateAndProceedToApp()
            })
            
            self?.window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func proceedToApp() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        print("User logged in status: \(isLoggedIn)")
        
        DispatchQueue.main.async { [weak self] in
            if isLoggedIn {
                self?.proceedToMainApp()
            } else {
                self?.proceedToLogin()
            }
        }
    }
    
    private func proceedToLogin() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = nav
    }
    
    private func proceedToMainApp() {
        let mainTabBarController = TabBarViewController()
        window?.rootViewController = mainTabBarController
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




