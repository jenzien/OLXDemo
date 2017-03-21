//
//  HomeRouterTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit
import XCTest

final class HomeRouterTests: XCTestCase {
    
    let searchRouterMock = SearchRouterMock()
    let viewModelMock = HomeViewModelMock()
    var homeRouter: HomeRouter!
    
    override func setUp() {
        homeRouter = HomeRouter(viewModel: viewModelMock, searchRouter: searchRouterMock)
    }
    
    func test_routeToSearch() {
        //Given
        searchRouterMock.routeToSearchCallCount = 0
        viewModelMock.presentSearchViewControllerCallCount = 0
        
        //When
        homeRouter.routeToSearch()
        
        //Verify
        XCTAssert(searchRouterMock.routeToSearchCallCount == 1)
        XCTAssert(viewModelMock.presentSearchViewControllerCallCount == 1)
        XCTAssert(homeRouter.children.count == 1)
    }
}
