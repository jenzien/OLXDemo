//
//  HomeViewModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/13/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol HomeViewableModel: ViewableModel {
    weak var listener: HomeViewModelListener? { get set }
    
    func presentSearchViewController(searchViewController: ViewControllable)
}

protocol HomeViewModelListener: class {
    func routeToSearch()
}

final class HomeViewModel: ViewModel<HomeViewControllable>, HomeViewableModel {
    
    weak var listener: HomeViewModelListener?
    
    override func activate() {
        listener?.routeToSearch()
    }
    
    func presentSearchViewController(searchViewController: ViewControllable) {
        viewController.showSearchViewController(searchViewController: searchViewController)
    }
}
