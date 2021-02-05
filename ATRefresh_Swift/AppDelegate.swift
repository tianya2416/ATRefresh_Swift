//
//  AppDelegate.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let age = 30
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible();
        self.window?.backgroundColor = UIColor.white;
        let nvc : UINavigationController = UINavigationController.init(rootViewController: ATViewController.init())
        self.window?.rootViewController = nvc;
        return true
    }
 
}
