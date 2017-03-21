//
//  HomeRouter.swift
//  OLX
//
//  Created by Jake Enzien on 3/14/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol HomeRouting: Routing {
}

class HomeRouter: Router<HomeViewableModel>, HomeRouting, HomeViewModelListener {
    let searchRouter: SearchRouting
    
    init(viewModel: HomeViewableModel,
         searchRouter: SearchRouting) {
        self.searchRouter = searchRouter
        super.init(viewModel: viewModel)
        
        viewModel.listener = self
    }
    
    func routeToSearch() {
        searchRouter.routeToSearch()
        attachChild(router: searchRouter)
        viewModel.presentSearchViewController(searchViewController: searchRouter.searchViewController)
    }
}
