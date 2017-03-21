//
//  SearchE2EUITests.swift
//  OLX
//
//  Created by Jake Enzien on 3/20/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

class SearchE2EUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        let collectionView = app.collectionViews[AccessibilityIdentifiers.searchViewController.rawValue]
        collectionView.swipeUp()
        collectionView.swipeUp()
        
        collectionView.swipeDown()
        
        XCTAssert(collectionView.cells.count > 0)
        
        let searchBar = app.searchFields.element
        searchBar.tap()
        searchBar.typeText("perros\n")
        
        XCTAssert(collectionView.cells.count > 0)
        
        collectionView.swipeUp()
        collectionView.swipeDown()
    }
    
}
