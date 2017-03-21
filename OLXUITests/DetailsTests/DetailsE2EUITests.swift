//
//  DetailsE2EUITests.swift
//  OLX
//
//  Created by Jake Enzien on 3/21/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

class DetailsE2EUITests: XCTestCase {
    
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
        let collectionView = XCUIApplication().collectionViews[AccessibilityIdentifiers.searchViewController.rawValue]
        collectionView.cells.element(boundBy: 0).tap()
        
        let moreButton = app.buttons[AccessibilityIdentifiers.detailsViewMoreButton.rawValue]
        moreButton.tap()
        moreButton.tap()
        
        app.navigationBars[AccessibilityIdentifiers.navigationBar.rawValue].buttons["Back"].tap()
        
        XCTAssert(collectionView.cells.count > 0)
    }
    
}
