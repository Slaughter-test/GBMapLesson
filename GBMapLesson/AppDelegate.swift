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
        let secretViewController = PrivacyProtectionViewController()
        window?.rootViewController = secretViewController
        window?.makeKeyAndVisible()
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        setMainApplication()
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
    
}

