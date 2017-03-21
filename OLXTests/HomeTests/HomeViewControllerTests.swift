//
//  HomeViewController.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

final class HomeViewContollerTests: XCTestCase {
    
    var homeViewController: HomeViewController!
    
    override func setUp() {
        homeViewController = HomeViewController()
    }
    
    func test_showSearchViewController() {
        //Given
        let viewControllableMock = ViewControllableMock()
        
        //When
        homeViewController.showSearchViewController(searchViewController: viewControllableMock)
        
        //Verify
        XCTAssert(viewControllableMock.viewController.navigationController != nil)
        XCTAssert(viewControllableMock.viewController.parent != nil)
        XCTAssert(homeViewController.view.subviews.count == 1)
    }
}
