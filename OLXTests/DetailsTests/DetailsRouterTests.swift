//
//  DetailsRouterTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/20/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

class DetailsRouterTests: XCTestCase {
    
    let detailsViewModelMock = DetailsViewModelMock()
    var detailsRouter: DetailsRouter!
    
    override func setUp() {
        detailsRouter = DetailsRouter(viewModel: detailsViewModelMock)
    }
    
    func test_routeToDetails() {
        //Given
        detailsViewModelMock.presentItemCallCount = 0
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
        //When
        detailsRouter.routeToItemDetails(item: itemModel)
        
        //Verify
        XCTAssertEqual(detailsViewModelMock.presentItemCallCount, 1)
    }
}
