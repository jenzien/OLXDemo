//
//  AppDelegate.swift
//  OLX
//
//  Created by Jake Enzien on 3/7/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import AlamofireNetworkActivityIndicator
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootRouter: Routing?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let homeComponent = HomeComponent(dependency: EmptyDependency())
        let homeBuilder = HomeBuilder(dependency: homeComponent)
        rootRouter = homeBuilder.build()
        window?.rootViewController = rootRouter?.viewableModel.viewControllable.viewController
        window?.makeKeyAndVisible()
        rootRouter?.viewableModel.activate()
        
        application.statusBarStyle = UIStatusBarStyle.lightContent

        UINavigationBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = Colors.olxDarkGreen
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        
    }

}

