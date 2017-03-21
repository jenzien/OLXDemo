//
//  DetailsViewModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/15/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsViewableModel: ViewableModel {
    
    weak var listener: DetailsViewModelListener? { get set }
    
    func presentItem(item: ItemModel)
}

protocol DetailsViewModelListener: class {
    func wantToDetach()
}

enum DetailsState {
    case more
    case less
}

final class DetailsViewModel: ViewModel<DetailsViewControllable>, DetailsViewableModel, DetailsViewControllerListener {
    
    weak var listener: DetailsViewModelListener?
    
    private var detailsState: DetailsState = .less
    
    override init(viewController: DetailsViewControllable) {
        super.init(viewController: viewController)
        viewController.listener = self
    }
    
    // MARK: - DetailsViewableModel
    
    func presentItem(item: ItemModel) {
        viewController.imageURL = URL(string: item.fullImage)
        viewController.titleText = item.title
        viewController.priceText = item.price?.displayPrice
        viewController.locationText = item.displayLocation
        viewController.descriptionText = item.description
        viewController.optionalFeatures = item.optionals?.reduce([String: String](), { (result, optionalModel) in
            if optionalModel.label == "" || optionalModel.value == "" {
                return result
            }
            var mutableResult = result
            mutableResult[optionalModel.label] = optionalModel.value
            return mutableResult
        })
    }
    
    // MARK: - DetailsViewControllerListener
    
    func didTapMoreLessButton() {
        switch detailsState {
        case .more:
            detailsState = .less
            viewController.showLess()
        case .less:
            detailsState = .more
            let height = viewController.viewController.view.frame.size.height / 2.0
            viewController.showMore(moreHeight: height)
        }
    }
    
    func viewWillDisappear() {
        listener?.wantToDetach()
    }
    
    func viewWillRotate(toSize size: CGSize) {
        switch detailsState {
        case .more:
            let height = size.height / 2.0
            viewController.showMore(moreHeight: height)
        case .less:
            viewController.showLess()
        }
    }
}
