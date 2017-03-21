//
//  ViewModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/7/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol ViewableModel: class {
    var viewControllable: ViewControllable { get }
    
    func activate()
    func deactivate()
}

class ViewModel<ViewControllerType>: ViewableModel {
    let viewControllable: ViewControllable
    let viewController: ViewControllerType
    
    init(viewController: ViewControllerType) {
        self.viewController = viewController
        
        guard let viewController = viewController as? ViewControllable else {
            fatalError("ViewController must be of type ViewControllable")
        }
        
        self.viewControllable = viewController
    }
    
    // MARK: - ViewableModel
    func activate() {}
    func deactivate() {}
}
