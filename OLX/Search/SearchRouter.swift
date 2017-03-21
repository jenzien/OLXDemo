//
//  SearchRouter.swift
//  OLX
//
//  Created by Jake Enzien on 3/14/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol SearchRouting: Routing {
    var searchViewController: ViewControllable { get }
    
    func routeToSearchResults(searchTerm: String)
    func routeToSearch()
}

class SearchRouter: Router<SearchViewableModel>, SearchRouting, SearchViewModelListener {
    
    let detailsBuilder: DetailsBuildable
    let searchBuilder: SearchBuildable
    let searchViewController: ViewControllable
    
    init(viewModel: SearchViewableModel,
         detailsBuilder: DetailsBuildable,
         searchBuilder: SearchBuildable,
         searchViewController: ViewControllable) {
        self.detailsBuilder = detailsBuilder
        self.searchBuilder = searchBuilder
        self.searchViewController = searchViewController
        super.init(viewModel: viewModel)
        
        viewModel.listener = self
    }
    
    // MARK: - SearchRouting
    func routeToSearchResults(searchTerm: String) {
        viewModel.presentSearchResults(searchTerm: searchTerm)
    }
    
    func routeToSearch() {
        viewModel.presentSearch()
    }
    
    // MARK: - SearchViewModelListener
    func wantDetailView(forItem item: ItemModel) {
        let router = detailsBuilder.build()
        let vc = router.viewableModel.viewControllable.viewController
        if let navigationController = searchViewController.viewController.navigationController {
            navigationController.pushViewController(vc, animated: true)
            router.routeToItemDetails(item: item)
            attachChild(router: router)
        }
    }
    
    func wantSearchResultsView(forSearchTerm search: String) {
        let router = searchBuilder.build()
        let vc = router.viewableModel.viewControllable.viewController
        if let navigationController = searchViewController.viewController.navigationController {
            navigationController.pushViewController(vc, animated: true)
            attachChild(router: router)
            router.routeToSearchResults(searchTerm: search)
        }
    }
    
    func wantToDetach() {
        detachFromParent()
    }
}
