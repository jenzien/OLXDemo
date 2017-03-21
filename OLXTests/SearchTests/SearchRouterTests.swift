//
//  SearchRouterTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/20/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

final class SearchRouterTests: XCTestCase {
    
    let searchViewModelMock = SearchViewModelMock()
    let detailsRouterMock = DetailsRouterMock()
    let searchRouterMock = SearchRouterMock()
    var detailsBuilderMock: DetailsBuilderMock!
    var searchBuilderMock: SearchBuilderMock!
    let searchViewControllerMock = SearchViewControllerMock()
    let viewController = UIViewController()
    var navigationController: UINavigationController!
    var searchRouter: SearchRouter!
    
    override func setUp() {
        navigationController = NavigationController(rootViewController: viewController)
        searchViewControllerMock.viewController = viewController
        
        detailsBuilderMock = DetailsBuilderMock(buildTypeMock: detailsRouterMock)
        searchBuilderMock = SearchBuilderMock(buildTypeMock: searchRouterMock)
        searchRouter = SearchRouter(viewModel: searchViewModelMock, detailsBuilder: detailsBuilderMock, searchBuilder: searchBuilderMock, searchViewController: searchViewControllerMock)
    }
    
    func test_routeToSearchResults() {
        //Given 
        searchViewModelMock.presentSearchResultsCallCount = 0
        
        //When
        searchRouter.routeToSearchResults(searchTerm: "")
        
        //Verify
        XCTAssertEqual(searchViewModelMock.presentSearchResultsCallCount, 1)
    }
    
    func test_routeToSearch() {
        //Given
        searchViewModelMock.presentSearchCallCount = 0
        
        //When
        searchRouter.routeToSearch()
        
        //Verify
        XCTAssertEqual(searchViewModelMock.presentSearchCallCount, 1)
    }
    
    func test_wantDetailView() {
        //Given
        detailsBuilderMock.buildCallCount = 0
        detailsRouterMock.setParentCallCount = 0
        detailsRouterMock.routeToItemDetailsCallCount = 0
        
        let itemModel = ItemModel(description: "",
                                  displayLocation: "",
                                  mediumImage: "",
                                  fullImage: "",
                                  thumbnail: "",
                                  imageWidth: nil,
                                  imageHeight: nil,
                                  title: "",
                                  price: nil,
                                  optionals: nil)
        
        //When
        searchRouter.wantDetailView(forItem: itemModel)
        
        //Verify
        XCTAssertEqual(detailsBuilderMock.buildCallCount, 1)
        XCTAssertEqual(detailsRouterMock.setParentCallCount, 1)
        XCTAssertEqual(detailsRouterMock.routeToItemDetailsCallCount, 1)
    }
    
    func test_wantSearchResultsView() {
        //Given
        searchBuilderMock.buildCallCount = 0
        searchRouterMock.setParentCallCount = 0
        searchRouterMock.routeToSearchResultsCallCount = 0
        
        //When
        searchRouter.wantSearchResultsView(forSearchTerm: "")
        
        //Verify
        XCTAssertEqual(searchBuilderMock.buildCallCount, 1)
        XCTAssertEqual(searchRouterMock.setParentCallCount, 1)
        XCTAssertEqual(searchRouterMock.routeToSearchResultsCallCount, 1)
    }
}
