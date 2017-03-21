//
//  ViewController.swift
//  OLX
//
//  Created by Jake Enzien on 3/7/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllable: class {
    var viewController: UIViewController { get }
    func attachChild(viewControllable: ViewControllable)
    func detachChild(viewControllable: ViewControllable)
}

extension ViewControllable {
    func attachChild(viewControllable: ViewControllable) {
        viewController.addChildViewController(viewControllable.viewController)
        viewController.view.addSubview(viewControllable.viewController.view)
    }
    
    func detachChild(viewControllable: ViewControllable) {
        viewControllable.viewController.removeFromParentViewController()
    }
}

class ViewController: UIViewController, ViewControllable {
    
    let theme: Theme
    
    var viewController: UIViewController {
        return self
    }
    
    init(theme: Theme = DefaultTheme()) {
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = theme.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented")
    }
}
