//
//  AppDelegate.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 07.11.2021.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // GoogleMaps API Key
        GMSServices.provideAPIKey("AIzaSyBagFDgBhRGy5UMIqCzupvD2I-KisUQiHE")
        
        setMainApplication()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        showPrivacyProtectionWindow()
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        hidePrivacyProtectionWindow()
    }
    
    private func setMainApplication() {
        // Launch Application
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.setNavigationBarHidden(false, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private var privacyProtectionWindow: UIWindow?

        private func showPrivacyProtectionWindow() {
            guard let windowScene = self.window?.windowScene else {
                return
            }

            privacyProtectionWindow = UIWindow(windowScene: windowScene)
            privacyProtectionWindow?.rootViewController = PrivacyProtectionViewController()
            privacyProtectionWindow?.windowLevel = .alert + 1
            privacyProtectionWindow?.makeKeyAndVisible()
        }

        private func hidePrivacyProtectionWindow() {
            privacyProtectionWindow?.isHidden = true
            privacyProtectionWindow = nil
        }
    
}

