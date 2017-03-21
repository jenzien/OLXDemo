//
//  DetailsRouter.swift
//  OLX
//
//  Created by Jake Enzien on 3/15/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsRouting: Routing {
    func routeToItemDetails(item: ItemModel)
}

protocol DetailsRouterListener: class {
    func detachFromParent()
}

final class DetailsRouter: Router<DetailsViewableModel>, DetailsRouting, DetailsViewModelListener {
    
    override init(viewModel: DetailsViewableModel) {
        super.init(viewModel: viewModel)
        viewModel.listener = self
    }
    
    // MARK: - DetailsRouting
    
    func routeToItemDetails(item: ItemModel) {
        viewModel.presentItem(item: item)
    }
    
    // MARK: - DetailsViewModelListener
    
    func wantToDetach() {
        detachFromParent()
    }
}
