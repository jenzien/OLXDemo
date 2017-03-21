//
//  Component.swift
//  OLX
//
//  Created by Jake Enzien on 3/8/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

class Component<ParentDependencyType>: Dependency {
    
    let dependency: ParentDependencyType
    var singletons: [ObjectIdentifier: AnyObject] = [:]
    
    required init(dependency: ParentDependencyType) {
        self.dependency = dependency
    }
    
    // MARK: - private
    func shared<SingletonType: AnyObject>(singleton: () -> SingletonType) -> SingletonType {
        let key = ObjectIdentifier(SingletonType.self)
        if let object = singletons[key] as? SingletonType {
            return object
        }
        
        let singletonObject = singleton()
        singletons[key] = singletonObject
        
        return singletonObject
    }
}
