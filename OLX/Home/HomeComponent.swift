//
//  HomeComponent.swift
//  OLX
//
//  Created by Jake Enzien on 3/9/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol HomeDependency {
    var searchRouter: SearchRouting { get }
    var networkEngine: NetworkEngine { get }
    var reachabilityManager: ReachabilityManaging { get }
}

final class HomeComponent: Component<Dependency>, HomeDependency {
    var searchRouter: SearchRouting {
        let searchComponent = SearchComponent(dependency: self)
        let searchBuilder = SearchBuilder(dependency: searchComponent)
        
        return searchBuilder.build()
    }
    
    var networkEngine: NetworkEngine {
        return shared {
            return AlamofireEngine()
        }
    }
    
    var reachabilityManager: ReachabilityManaging {
        return shared {
            return ReachabilityManager()
        }
    }
}
