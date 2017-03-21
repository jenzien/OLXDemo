//
//  SearchViewControllerTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/20/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

class SearchViewControllerTests: XCTestCase {
    
    let searchViewControllerListenerMock = SearchCollectionViewControllerListenerMock()
    var searchViewController: SearchCollectionViewController!
    var collectionView: UICollectionView!
    
    override func setUp() {
        searchViewController = SearchCollectionViewController()
        searchViewController.listener = searchViewControllerListenerMock
        collectionView = searchViewController.collectionView
    }
    
    func test_showSearchResultsCount() {
        //When
        searchViewController.showSearchResultsCount(totalResults: 20)
        
        //Verify
        XCTAssert(searchViewController.navigationItem.titleView == nil)
        XCTAssertEqual(searchViewController.navigationItem.title, "20 \(OLXStrings.resultsString())")
    }
    
    func test_numberOfSections() {
        //When
        let sectionCount = searchViewController.numberOfSections(in: collectionView)
        //Verify
        XCTAssertEqual(sectionCount, 1)
    }
    
    func test_cellForItemAtIndexPath() {
        //Given
        let title = "Porsche 918 Spyder"
        let price = "$1"
        let imageURL = "https://porsche.com"
        
        let priceModel = PriceModel(amount: 1, displayPrice: price)
        let itemModel = ItemModel(description: "",
                                  displayLocation: "",
                                  mediumImage: "",
                                  fullImage: imageURL,
                                  thumbnail: "",
                                  imageWidth: nil,
                                  imageHeight: nil,
                                  title: title,
                                  price: priceModel,
                                  optionals: nil)
        searchViewController.items = [itemModel]
        
        //When
        let cell = searchViewController.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as! SearchCollectionViewCell
        
        //Verify
        XCTAssertEqual(cell.title.text, title)
        XCTAssertEqual(cell.price.text, price)
        XCTAssertEqual(cell.image.imageURL?.absoluteString, imageURL)
    }
    
    func test_didSelectItemAtIndexPath() {
        //Given
        searchViewControllerListenerMock.didSelectItemCallCount = 0
        let title = "Porsche 918 Spyder"
        let price = "$1"
        let imageURL = "https://porsche.com"
        
        let priceModel = PriceModel(amount: 1, displayPrice: price)
        let itemModel = ItemModel(description: "",
                                  displayLocation: "",
                                  mediumImage: "",
                                  fullImage: imageURL,
                                  thumbnail: "",
                                  imageWidth: nil,
                                  imageHeight: nil,
                                  title: title,
                                  price: priceModel,
                                  optionals: nil)
        searchViewController.items = [itemModel]
        
        //When
        searchViewController.collectionView(collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        
        //Verify
        XCTAssertEqual(searchViewControllerListenerMock.didSelectItemCallCount, 1)
    }
    
    func test_searchBarSearchButtonClicked() {
        //Given
        searchViewControllerListenerMock.searchBarDidSearchCallCount = 0
        let searchBar = UISearchBar()
        searchBar.text = "porsche"
        
        //When
        searchViewController.searchBarSearchButtonClicked(searchBar)
        
        //Verify
        XCTAssertEqual(searchViewControllerListenerMock.searchBarDidSearchCallCount, 1)
    }
    
    func test_scrollViewDidEndDecelerating() {
        //Given
        collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentSize.height), animated: false)
        
        //When
        searchViewController.scrollViewDidEndDecelerating(collectionView)
        
        //Verify
        XCTAssertEqual(searchViewControllerListenerMock.scrollViewDidScrollToBottomCallCount, 1)
    }
}
