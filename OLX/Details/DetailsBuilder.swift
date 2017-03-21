//
//  DetailsBuilder.swift
//  OLX
//
//  Created by Jake Enzien on 3/15/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsBuildable {
    func build() -> DetailsRouting
}

final class DetailsBuilder: Builder<DetailsRouting, DetailsDependency>, DetailsBuildable {
    
    override func build() -> DetailsRouting {
        let detailsViewController = DetailsViewController()
        let detailsViewModel = DetailsViewModel(viewController: detailsViewController)
        let detailsRouter = DetailsRouter(viewModel: detailsViewModel)
        
        return detailsRouter
    }
}
