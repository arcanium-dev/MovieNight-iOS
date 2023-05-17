//
//  AppDelegate.swift
//  MovieNight-iOS
//
//  Created by Muneeb Bray on 2023/05/13.
//

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let window = UIWindow()
        window.makeKeyAndVisible()
        let navController = UINavigationController(rootViewController: HomeViewController())
        navController.navigationBar.barStyle = .default
        window.rootViewController = navController
        
        
//
//        let rootWindow = UIWindow(frame: UIScreen.main.bounds)
//        rootWindow.makeKeyAndVisible()
//        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        rootWindow.rootViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//        self.window = rootWindow
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

