//
//  DetailsViewControllerTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/20/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

class DetailsViewControllerTests: XCTestCase {
    
    let detailsViewControllerListenerMock = DetailsViewControllerListenerMock()
    var detailsViewController: DetailsViewController!
    
    override func setUp() {
        detailsViewController = DetailsViewController()
        detailsViewController.listener = detailsViewControllerListenerMock
    }
    
    func test_didTapMore() {
        //Given
        detailsViewControllerListenerMock.didTapMoreLessButtonCallCount = 0
        
        //When
        detailsViewController.didTapMore()
        
        //Verify
        XCTAssertEqual(detailsViewControllerListenerMock.didTapMoreLessButtonCallCount, 1)
    }
}
