//
//  HomeViewController.swift
//  OLX
//
//  Created by Jake Enzien on 3/9/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol HomeViewControllable: ViewControllable {
    func showSearchViewController(searchViewController: ViewControllable)
}

final class HomeViewController: ViewController, HomeViewControllable {
    
    private var rootNavigationController: NavigationControllable?
    
    override init(theme: Theme = DefaultTheme()) {
        
        super.init(theme: theme)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - HomeViewControllable
    func showSearchViewController(searchViewController: ViewControllable) {
        rootNavigationController = NavigationController(rootViewController: searchViewController.viewController)
        
        if let rootNavigationController = rootNavigationController {
            attachChild(viewControllable: rootNavigationController)
        }
    }
}
