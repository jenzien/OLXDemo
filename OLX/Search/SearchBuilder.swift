//
//  SearchBuilder.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol SearchBuildable {
    func build() -> SearchRouting
}

final class SearchBuilder: Builder<SearchRouting, SearchDependency>, SearchBuildable {
    
    override func build() -> SearchRouting {
        let viewController = SearchCollectionViewController()
        let viewModel = SearchViewModel(viewController: viewController, olxService: dependency.olxService, reachabilityManager: dependency.reachabilityManager)
        let router = SearchRouter(viewModel: viewModel, detailsBuilder: dependency.detailsBuilder, searchBuilder: dependency.searchBuilder,searchViewController: viewController)
        return router
    }
}
