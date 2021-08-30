//
//  AppDelegate.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import UIKit
import ArgoKit
import ArgoKitPreview
import ArgoKitComponent

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        _argokit_preview_config_()
        ArgoKitPreview_FitFlex();
        #endif
        var nav: UINavigationController?
        let vc = HomeMainViewController()
        nav = UINavigationController(rootViewController: vc)
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
        UINavigationBar.appearance().barTintColor = .white
        return true
    }
}

