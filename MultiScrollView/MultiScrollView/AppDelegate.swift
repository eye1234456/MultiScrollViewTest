//
//  AppDelegate.swift
//  MultiScrollView
//
//  Created by AAA on 11/10/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 15.0, *) {
                let appperance = UINavigationBarAppearance()
                //添加背景色
                appperance.backgroundColor = UIColor.red;
                appperance.shadowImage = UIImage()
                appperance.shadowColor = nil
                //设置字体颜色大小
                appperance.titleTextAttributes = [.foregroundColor: UIColor.white]
                
                UINavigationBar.appearance().standardAppearance = appperance;
                UINavigationBar.appearance().scrollEdgeAppearance = appperance;
                UINavigationBar.appearance().compactAppearance = appperance;
                UINavigationBar.appearance().compactScrollEdgeAppearance = appperance;
        }else {
            UINavigationBar.appearance().tintColor = .red //前景色，按钮颜色
            UINavigationBar.appearance().barTintColor = .white //背景色，导航条背景色
            UINavigationBar.appearance().isTranslucent = false // 导航条背景是否透明
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
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

