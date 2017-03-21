//
//  SearchComponent.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol SearchDependency: Dependency {
    var olxService: OLXServicing { get }
    var detailsBuilder: DetailsBuildable { get }
    var searchBuilder: SearchBuildable { get }
    var reachabilityManager: ReachabilityManaging { get }
}

final class SearchComponent: Component<HomeDependency>, SearchDependency {
    
    var olxService: OLXServicing {
        return shared {
            return OLXService(networkEngine: dependency.networkEngine)
        }
    }
    
    var detailsBuilder: DetailsBuildable {
        let detailsComponent = DetailsComponent(dependency: self)
        let detailsBuilder = DetailsBuilder(dependency: detailsComponent)
        return detailsBuilder
    }
    
    var searchBuilder: SearchBuildable {
        let searchBuilder = SearchBuilder(dependency: self)
        return searchBuilder
    }
    var reachabilityManager: ReachabilityManaging {
        return dependency.reachabilityManager
    }
}
