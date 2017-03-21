//
//  NavigationController.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationControllable: ViewControllable {
    var uinavigationController: UINavigationController { get }
}

class NavigationController: UINavigationController, NavigationControllable {
    
    var viewController: UIViewController {
        return self
    }
    
    var uinavigationController: UINavigationController {
        return self
    }
}
