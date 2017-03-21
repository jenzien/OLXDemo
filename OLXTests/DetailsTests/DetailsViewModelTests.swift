//
//  DetailsViewModelTests.swift
//  OLX
//
//  Created by Jake Enzien on 3/20/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import XCTest

class DetailsViewModelTests: XCTestCase {
    
    let detailsViewControllerMock = DetailsViewControllerMock()
    let detailsViewModelListenerMock = DetailsViewModelListenerMock()
    var detailsViewModel: DetailsViewModel!
    
    override func setUp() {
        detailsViewModel = DetailsViewModel(viewController: detailsViewControllerMock)
        detailsViewModel.listener = detailsViewModelListenerMock
    }
    
    func test_presentItem() {
        //Given 
        let title = "Porsche 918 Spyder"
        let imageURL = "https://porsche.com"
        let price = "$1"
        let location = "Nurburgring"
        let neighborhood = "Track"
        let description = "Fastest best hybrid"
        let optionalLabel = "Year"
        let optionalValue = "2015"
        let priceModel = PriceModel(amount: 1, displayPrice: price)
        let optionalModel = OptionalModel(label: optionalLabel, value: optionalValue)
        
        let itemModel = ItemModel(description: description,
                                  displayLocation: location,
                                  neighborhood: neighborhood,
                                  mediumImage: "",
                                  fullImage: imageURL,
                                  thumbnail: "",
                                  imageWidth: nil,
                                  imageHeight: nil,
                                  title: title,
                                  price: priceModel,
                                  optionals: [optionalModel])
        
        //When
        detailsViewModel.presentItem(item: itemModel)
        
        //Verify
        XCTAssertEqual(detailsViewControllerMock.imageURL?.absoluteString, imageURL)
        XCTAssertEqual(detailsViewControllerMock.titleText, title)
        XCTAssertEqual(detailsViewControllerMock.priceText, price)
        XCTAssertEqual(detailsViewControllerMock.locationText, "\(location), \(neighborhood)")
        XCTAssertEqual(detailsViewControllerMock.descriptionText, description)
        XCTAssertEqual(detailsViewControllerMock.optionalFeatures!, [optionalLabel: optionalValue])
    }
    
    func test_didTapMoreLessButton() {
        //Given
        detailsViewControllerMock.showMoreCallCount = 0
        detailsViewControllerMock.showLessCallCount = 0
        
        //When
        detailsViewModel.didTapMoreLessButton()
        detailsViewModel.didTapMoreLessButton()
        
        //Verify
        XCTAssertEqual(detailsViewControllerMock.showMoreCallCount, 1)
        XCTAssertEqual(detailsViewControllerMock.showLessCallCount, 1)
    }
    
    func test_viewWillDisappear() {
        //Given
        detailsViewModelListenerMock.wantToDetachCallCount = 0
        
        //When
        detailsViewModel.viewWillDisappear()
        
        //Verify
        XCTAssertEqual(detailsViewModelListenerMock.wantToDetachCallCount, 1)
    }
    
    func test_viewWillRotate() {
        //Given
        detailsViewControllerMock.showMoreCallCount = 0
        detailsViewControllerMock.showLessCallCount = 0
        
        //When
        detailsViewModel.viewWillRotate(toSize: CGSize.zero)
        
        //Verify
        XCTAssertEqual(detailsViewControllerMock.showLessCallCount, 1)
    }
}
