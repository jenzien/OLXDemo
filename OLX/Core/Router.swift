//
//  Router.swift
//  OLX
//
//  Created by Jake Enzien on 3/13/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol Routing: class {
    weak var parent: Routing? { get set }
    
    var viewableModel: ViewableModel { get }
    
    func attachChild(router: Routing)
    func detachChild(router: Routing)
    func detachFromParent()
}

class Router<ViewModelType>: Routing {
    
    weak var parent: Routing?
    
    let viewableModel: ViewableModel
    let viewModel: ViewModelType
    var children: [ObjectIdentifier: Routing] = [:]
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        guard let viewModel = viewModel as? ViewableModel else {
            fatalError("ViewModelType should conform to ViewableModel")
        }
        
        self.viewableModel = viewModel
    }
    
    deinit {
        for child in children {
            child.value.viewableModel.deactivate()
        }
    }
    
    // MARK: - Routing
    
    func attachChild(router: Routing) {
        let key = ObjectIdentifier(router)
        OLXAssert(children[key] == nil, message: "Attempt to add child that is already attached to this router")
        
        synchronized(children) {
            children[key] = router
            router.parent = self
        }
        
        router.viewableModel.activate()
    }
    
    func detachChild(router: Routing) {
        let key = ObjectIdentifier(router)
        let child = children[key]
        OLXAssert(child != nil, message: "Attempting to remove a child that is not attached to this router")
        
        synchronized(children) {
            children.removeValue(forKey: key)
            child?.parent = nil
        }
        
        child?.viewableModel.deactivate()
    }
    
    func detachFromParent() {
        if let parent = parent {
            parent.detachChild(router: self)
        }
    }
}
