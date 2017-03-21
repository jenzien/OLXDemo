//
//  HomeBuilder.swift
//  OLX
//
//  Created by Jake Enzien on 3/9/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

final class HomeBuilder: Builder<HomeRouting, HomeDependency> {
    
    override func build() -> HomeRouting {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(viewController: viewController)
        let router = HomeRouter(viewModel: viewModel, searchRouter: dependency.searchRouter)
        return router
    }
}
