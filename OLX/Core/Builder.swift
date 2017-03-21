//
//  Builder.swift
//  OLX
//
//  Created by Jake Enzien on 3/7/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol Buildable {
    associatedtype BuildType
    
    func build() -> BuildType
}

class Builder<BuildType, DependencyType>: Buildable {
 
    let dependency: DependencyType
    
    required init(dependency: DependencyType) {
        self.dependency = dependency
    }
    
    func build() -> BuildType {
        fatalError("Not Implemented")
    }
}
