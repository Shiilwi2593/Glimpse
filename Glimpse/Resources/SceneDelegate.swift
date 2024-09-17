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
        var hasWaitedThreeSeconds = false
        
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)
            window?.windowScene = windowScene
            
            locationManager.delegate = self
            
            let startViewController = StartViewController()
            window?.rootViewController = startViewController
            window?.makeKeyAndVisible()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.hasWaitedThreeSeconds = true
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.window?.rootViewController?.view.alpha = 0
                }, completion: { _ in
                    self.checkLocationAuthorizationIfReady()
                })
            }

        }
        
        func checkLocationAuthorizationIfReady() {
            guard hasWaitedThreeSeconds else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                switch locationManager.authorizationStatus {
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    showAlertForLocationAccess()
                case .authorizedAlways, .authorizedWhenInUse:
                    proceedToApp()
                @unknown default:
                    proceedToApp()
                }
            } else {
                showAlertForLocationAccess()
            }
        }
        
        func showAlertForLocationAccess() {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Vị trí bị hạn chế",
                                              message: "Bạn cần bật quyền truy cập vị trí để sử dụng ứng dụng này.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cài đặt", style: .default, handler: { _ in
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: { _ in
                    self.proceedToApp()
                }))
                self.window?.rootViewController?.present(alert, animated: true)
            }
        }
        
        func proceedToApp() {
            DispatchQueue.main.async {
                if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                    self.proceedToMainApp()
                } else {
                    self.proceedToLogin()
                }
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorizationIfReady()
        }
        
        func proceedToLogin() {
            let loginVw = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVw)
            self.window?.rootViewController = nav
        }
        
        func proceedToMainApp() {
            let mainTabBarController = TabBarViewController()
            self.window?.rootViewController = mainTabBarController
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




