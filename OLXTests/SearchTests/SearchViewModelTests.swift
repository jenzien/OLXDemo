//
//  SearchViewModelTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/20/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

class SearchViewModelTests: XCTestCase {
    
    let searchViewControllerMock = SearchViewControllerMock()
    let olxServiceMock = OLXServiceMock()
    let reachabilityManagerMock = ReachabilityManagerMock()
    let searchViewModelListenerMock = SearchViewModelListenerMock()
    let itemModel = ItemModel(description: "",
                              displayLocation: "",
                              neighborhood: nil,
                              mediumImage: "",
                              fullImage: "",
                              thumbnail: "",
                              imageWidth: nil,
                              imageHeight: nil,
                              title: "",
                              price: nil,
                              optionals: nil)
    
    var searchViewModel: SearchViewModel!
    
    override func setUp() {
        searchViewModel = SearchViewModel(viewController: searchViewControllerMock, olxService: olxServiceMock, reachabilityManager: reachabilityManagerMock)
        searchViewModel.listener = searchViewModelListenerMock
    }
    
    func test_presentSearchResults() {
        //Given
        searchViewControllerMock.showSearchResultsCountCallCount = 0
        searchViewControllerMock.setItemsCallCount = 0
        searchViewControllerMock.hideErrorViewCallCount = 0
        searchViewControllerMock.showSearchResultsCountCallCount = 0
        olxServiceMock.getItemsCallCount = 0
        olxServiceMock.itemModelFixture = ItemsModel(items: [itemModel], total: 1)
        
        //When
        searchViewModel.presentSearchResults(searchTerm: "")
        
        //Verify
        XCTAssertEqual(searchViewControllerMock.showSearchResultsCountCallCount, 2)
        XCTAssertEqual(searchViewControllerMock.setItemsCallCount, 1)
        XCTAssertEqual(olxServiceMock.getItemsCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.hideErrorViewCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.showErrorViewCallCount, 0)
    }
    
    func test_presentSearch() {
        //Given
        searchViewControllerMock.showSearchResultsCountCallCount = 0
        searchViewControllerMock.setItemsCallCount = 0
        searchViewControllerMock.hideErrorViewCallCount = 0
        olxServiceMock.getItemsCallCount = 0
        olxServiceMock.itemModelFixture = ItemsModel(items: [itemModel], total: 1)
        
        //When
        searchViewModel.presentSearch()
        
        //Verify
        XCTAssertEqual(searchViewControllerMock.showSearchResultsCountCallCount, 0)
        XCTAssertEqual(searchViewControllerMock.setItemsCallCount, 1)
        XCTAssertEqual(olxServiceMock.getItemsCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.hideErrorViewCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.showErrorViewCallCount, 0)
    }
    
    func test_presentSearchError() {
        //Given
        searchViewControllerMock.showSearchResultsCountCallCount = 0
        searchViewControllerMock.setItemsCallCount = 0
        searchViewControllerMock.hideErrorViewCallCount = 0
        olxServiceMock.getItemsCallCount = 0
        olxServiceMock.errorFixture = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: ""])
        
        //When
        searchViewModel.presentSearch()
        
        //Verify
        XCTAssertEqual(searchViewControllerMock.showSearchResultsCountCallCount, 0)
        XCTAssertEqual(searchViewControllerMock.setItemsCallCount, 0)
        XCTAssertEqual(olxServiceMock.getItemsCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.hideErrorViewCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.showErrorViewCallCount, 1)
    }
    
    func test_searchBarDidSearch() {
        //Given
        searchViewModelListenerMock.wantSearchResultsViewCallCount = 0
        
        //When
        searchViewModel.searchBarDidSearch(forText: "")
        
        //Verify
        XCTAssertEqual(searchViewModelListenerMock.wantSearchResultsViewCallCount, 1)
    }
    
    func test_scrollViewDidScrollToBottom() {
        //Given
        searchViewControllerMock.showSearchResultsCountCallCount = 0
        searchViewControllerMock.setItemsCallCount = 0
        searchViewControllerMock.hideErrorViewCallCount = 0
        searchViewControllerMock.showSearchResultsCountCallCount = 0
        olxServiceMock.getItemsCallCount = 0
        
        olxServiceMock.itemModelFixture = ItemsModel(items: [itemModel], total: 1)
        
        //When
        searchViewModel.scrollViewDidScrollToBottom()
        
        //Verify
        XCTAssertEqual(searchViewControllerMock.showSearchResultsCountCallCount, 0)
        XCTAssertEqual(searchViewControllerMock.setItemsCallCount, 1)
        XCTAssertEqual(olxServiceMock.getItemsCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.hideErrorViewCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.showErrorViewCallCount, 0)
    }
    
    func test_didSelectItem() {
        //Given
        searchViewModelListenerMock.wantDetailViewCallCount = 0
        
        //When
        searchViewModel.didSelectItem(item: itemModel)
        
        //Verify
        XCTAssertEqual(searchViewModelListenerMock.wantDetailViewCallCount, 1)
    }
    
    func test_refreshData() {
        //Given
        searchViewControllerMock.showSearchResultsCountCallCount = 0
        searchViewControllerMock.setItemsCallCount = 0
        searchViewControllerMock.hideErrorViewCallCount = 0
        olxServiceMock.getItemsCallCount = 0
        olxServiceMock.itemModelFixture = ItemsModel(items: [itemModel], total: 1)
        
        //When
        searchViewModel.refreshData()
        
        //Verify
        XCTAssertEqual(searchViewControllerMock.showSearchResultsCountCallCount, 0)
        XCTAssertEqual(searchViewControllerMock.setItemsCallCount, 2)
        XCTAssertEqual(olxServiceMock.getItemsCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.hideErrorViewCallCount, 1)
        XCTAssertEqual(searchViewControllerMock.showErrorViewCallCount, 0)
    }
    
    func test_viewWillDisappear() {
        //Given
        searchViewModelListenerMock.wantToDetachCallCount = 0
        
        //When
        searchViewModel.viewWillDisappear()
        
        //Verify
        XCTAssertEqual(searchViewModelListenerMock.wantToDetachCallCount, 1)
    }
}
