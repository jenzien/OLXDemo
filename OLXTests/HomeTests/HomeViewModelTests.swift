//
//  HomeViewModelTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

final class HomeViewModelTests: XCTestCase {
    
    let homeViewControllerMock = HomeViewControllerMock()
    let homeViewModelListenerMock = HomeViewModelListenerMock()
    var homeViewModel: HomeViewModel!
    
    override func setUp() {
        homeViewModel = HomeViewModel(viewController: homeViewControllerMock)
        homeViewModel.listener = homeViewModelListenerMock
    }
    
    func test_activate() {
        //Given
        homeViewModelListenerMock.routeToSearchCallCount = 0
        
        //When
        homeViewModel.activate()
        
        //Verify
        XCTAssertEqual(homeViewModelListenerMock.routeToSearchCallCount, 1)
    }
    
    func test_presentHomeViewController() {
        //Given
        homeViewControllerMock.showSearchViewControllerCallCount = 0
        
        //When
        homeViewModel.presentSearchViewController(searchViewController: ViewControllableMock())
        
        //Verify
        XCTAssert(homeViewControllerMock.showSearchViewControllerCallCount == 1)
    }
}
