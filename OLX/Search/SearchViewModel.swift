//
//  SearchViewModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol SearchViewableModel: ViewableModel {
    weak var listener: SearchViewModelListener? { get set }
    
    func presentSearchResults(searchTerm: String)
    func presentSearch()
}

protocol SearchViewModelListener: class {
    func wantDetailView(forItem item: ItemModel)
    func wantSearchResultsView(forSearchTerm search: String)
    func wantToDetach()
}

final class SearchViewModel: ViewModel<SearchCollectionViewControllable>, SearchViewableModel, SearchCollectionViewControllerListener {
    private enum Mode {
        case search
        case results
    }

    
    weak var listener: SearchViewModelListener?
    
    private let olxService: OLXServicing
    private let location = "www.olx.com.ar"
    private let reachabilityManager: ReachabilityManaging
    
    private var currentSearch: String = ""
    private var loading = false
    private var mode: Mode = .search
    
    init(viewController: SearchCollectionViewControllable,
         olxService: OLXServicing,
         reachabilityManager: ReachabilityManaging) {
        self.olxService = olxService
        self.reachabilityManager = reachabilityManager
        super.init(viewController: viewController)
        
        viewController.listener = self
    }
    
    // MARK: - SearchViewableModel
    
    func presentSearchResults(searchTerm: String) {
        mode = .results
        currentSearch = searchTerm
        viewController.showSearchResultsCount(totalResults: 0)
        performSearch(search: currentSearch)
    }
    
    func presentSearch() {
        performSearch(search: currentSearch)
    }
    
    // MARK: - SearchCollectionViewControllerListener
    
    func searchBarDidSearch(forText search: String) {
        listener?.wantSearchResultsView(forSearchTerm: search)
    }
    
    func scrollViewDidScrollToBottom() {
        performSearch(search: currentSearch, pageSize: 10, offset: viewController.items.count)
    }
    
    func didSelectItem(item: ItemModel) {
        listener?.wantDetailView(forItem: item)
    }
    
    func refreshData() {
        viewController.items = []
        performSearch(search: currentSearch)
    }
    
    func viewWillDisappear() {
        listener?.wantToDetach()
    }
    
    // MARK: - private
    private func showError() {
        var error: String = ""
        switch reachabilityManager.status {
        case .reachable:
            error = OLXStrings.noResultsError()
        default:
            error = OLXStrings.noNetworkError()
        }
        
        viewController.showErrorView(errorMessage: error)
    }
    
    private func performSearch(search: String, pageSize: Int = 50, offset: Int = 0) {
        if !loading {
            viewController.hideErrorView()
            loading = true
            olxService.getItems(location: location, searchTerm: search, pageSize: pageSize, offset: offset) { [weak self] (model, error) in
                self?.loading = false
                if let model = model {
                    if self?.mode == .results {
                        self?.viewController.showSearchResultsCount(totalResults: model.total)
                    }
                    
                    if model.items.count == 0 {
                        self?.showError()
                    } else if offset == 0 {
                        self?.viewController.items = model.items
                    } else {
                        self?.viewController.items.append(contentsOf: model.items)
                    }
                } else if let error = error {
                    // TODO: - Display error message
                    Logger.log(message: error.localizedDescription)
                    self?.showError()
                }
                
            }
        }
    }
}
