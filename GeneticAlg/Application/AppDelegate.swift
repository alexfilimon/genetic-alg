//
//  AppDelegate.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = DrawViewController()
        window?.makeKeyAndVisible()
        
        return true
    }


}

