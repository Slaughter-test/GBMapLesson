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
        
        // Launch Application
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let viewController = ViewController()
        viewController.title = "Map"
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(false, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
}

