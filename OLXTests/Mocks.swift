//
//  Mocks.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Alamofire
import Freddy
import Foundation
import UIKit

// MARK: - Networking mocks

class NetworkEngineMock: NetworkEngine {
    
    var enqueueCallCount = 0
    
    func enqueue<Model : JSONDecodable>(url: URL, params: [String : String], forceCache: Bool, completion: @escaping (Model?, Error?) -> ()) {
        enqueueCallCount += 1
    }
}

class ServiceMock: Servicing {
    
    var networkEngine: NetworkEngine
    
    convenience init() {
        self.init(networkEngine: NetworkEngineMock())
    }
    
    required init(networkEngine: NetworkEngine) {
        self.networkEngine = networkEngine
    }
}

class OLXServiceMock: ServiceMock, OLXServicing {
    
    var getItemsCallCount = 0
    
    var itemModelFixture: ItemsModel?
    var errorFixture: Error?
    
    func getItems(location: String, searchTerm: String, pageSize: Int?, offset: Int?, completion: @escaping (ItemsModel?, Error?) -> ()) {
        getItemsCallCount += 1
        completion(itemModelFixture, errorFixture)
    }
}

class ReachabilityManagerMock: ReachabilityManaging {
    
    var status: NetworkReachabilityManager.NetworkReachabilityStatus = .reachable(.ethernetOrWiFi)
}

// MARK: - Core mocks

class ViewControllableMock: ViewControllable {
    var viewController: UIViewController = UIViewController() {
        didSet {
            setViewControllerCallCount += 1
        }
    }
    
    var setViewControllerCallCount = 0
    var attachChildCallCount = 0
    var detachChildCallCount = 0
    
    func attachChild(viewControllable: ViewControllable) {
        attachChildCallCount += 1
    }
    
    func detachChild(viewControllable: ViewControllable) {
        detachChildCallCount += 1
    }
}

class ViewModelMock: ViewableModel {
    var viewControllable: ViewControllable = ViewControllableMock() {
        didSet {
            setViewControllableCallCount += 1
        }
    }
    
    var setViewControllableCallCount = 0
    var setRouterCallCount = 0
    var activateCallCount = 0
    var deactivateCallCount = 0
    
    func activate() {
        activateCallCount += 1
    }
    
    func deactivate() {
        deactivateCallCount += 1
    }
}

class RouterMock: Routing {
    
    var setParentCallCount = 0
    var setViewableModelCallCount = 0
    var attachChildCallCount = 0
    var detachChildCallCount = 0
    var detachFromParentCallCount = 0
    
    weak var parent: Routing? {
        didSet {
            setParentCallCount += 1
        }
    }
    
    var viewableModel: ViewableModel = ViewModelMock() {
        didSet {
            setViewableModelCallCount += 1
        }
    }
    
    func attachChild(router: Routing) {
        attachChildCallCount += 1
    }
    
    func detachChild(router: Routing) {
        detachChildCallCount += 1
    }
    
    func detachFromParent() {
        detachFromParentCallCount += 1
    }
}

class BuilderMock<BuildableType>: Buildable {
    
    var buildCallCount = 0
    
    typealias BuildType = BuildableType
    
    let buildTypeMock: BuildableType
    init(buildTypeMock: BuildableType) {
        self.buildTypeMock = buildTypeMock
    }
    
    func build() -> BuildableType {
        buildCallCount += 1
        return buildTypeMock
    }
}

// MARK: - Home mocks
class HomeViewModelMock: ViewModelMock, HomeViewableModel {
    weak var listener: HomeViewModelListener? {
        didSet {
            setListenerCallCount += 1
        }
    }
    
    var setListenerCallCount = 0
    var presentSearchViewControllerCallCount = 0
    
    func presentSearchViewController(searchViewController: ViewControllable) {
        presentSearchViewControllerCallCount += 1
    }
}

class HomeViewControllerMock: ViewControllableMock, HomeViewControllable {
    
    var showSearchViewControllerCallCount = 0
    func showSearchViewController(searchViewController: ViewControllable) {
        showSearchViewControllerCallCount += 1
    }
}

class HomeViewModelListenerMock: HomeViewModelListener {
    
    var routeToSearchCallCount = 0
    
    func routeToSearch() {
        routeToSearchCallCount += 1
    }
}

// MARK: - Search mocks
class SearchBuilderMock: BuilderMock<SearchRouting>, SearchBuildable { }

class SearchRouterMock: RouterMock, SearchRouting {
    
    var setSearchViewControllerCallCount = 0
    var routeToSearchResultsCallCount = 0
    var routeToSearchCallCount = 0
    var routeToDetailViewCallCount = 0
    
    var searchViewController: ViewControllable = ViewControllableMock() {
        didSet {
            setSearchViewControllerCallCount += 1
        }
    }
    
    func routeToSearchResults(searchTerm: String) {
        routeToSearchResultsCallCount += 1
    }
    
    func routeToSearch() {
        routeToSearchCallCount += 1
    }
    
    func routeToDetailView(forItem item: ItemModel) {
        routeToDetailViewCallCount += 1
    }
}

class SearchViewModelMock: ViewModelMock, SearchViewableModel {
    
    var setListenerCallCount = 0
    var presentSearchResultsCallCount = 0
    var presentSearchCallCount = 0
    
    weak var listener: SearchViewModelListener? {
        didSet {
            setListenerCallCount += 1
        }
    }
    
    func presentSearchResults(searchTerm: String) {
        presentSearchResultsCallCount += 1
    }
    
    func presentSearch() {
        presentSearchCallCount += 1
    }
}

class SearchViewControllerMock: ViewControllableMock, SearchCollectionViewControllable {
    
    var setListenerCallCount = 0
    var setItemsCallCount = 0
    var showSearchResultsCountCallCount = 0
    var showErrorViewCallCount = 0
    var hideErrorViewCallCount = 0
    
    weak var listener: SearchCollectionViewControllerListener? {
        didSet {
            setListenerCallCount += 1
        }
    }
    
    var items: [ItemModel] = [] {
        didSet {
            setItemsCallCount += 1
        }
    }
    
    func showSearchResultsCount(totalResults: Int) {
        showSearchResultsCountCallCount += 1
    }
    
    func showErrorView(errorMessage: String) {
        showErrorViewCallCount += 1
    }
    
    func hideErrorView() {
        hideErrorViewCallCount += 1
    }
}

class SearchViewModelListenerMock: SearchViewModelListener {
    
    var wantDetailViewCallCount = 0
    var wantSearchResultsViewCallCount = 0
    
    func wantDetailView(forItem item: ItemModel) {
        wantDetailViewCallCount += 1
    }
    
    func wantSearchResultsView(forSearchTerm search: String) {
        wantSearchResultsViewCallCount += 1
    }
}

class SearchCollectionViewControllerListenerMock: SearchCollectionViewControllerListener {
    
    var searchBarDidSearchCallCount = 0
    var scrollViewDidScrollToBottomCallCount = 0
    var didSelectItemCallCount = 0
    var refreshDataCallCount = 0
    
    func searchBarDidSearch(forText search: String) {
        searchBarDidSearchCallCount += 1
    }
    
    func scrollViewDidScrollToBottom() {
        scrollViewDidScrollToBottomCallCount += 1
    }
    
    func didSelectItem(item: ItemModel) {
        didSelectItemCallCount += 1
    }
    
    func refreshData() {
        refreshDataCallCount += 1
    }
}

// MARK: - Details mocks
class DetailsBuilderMock: BuilderMock<DetailsRouting>, DetailsBuildable { }

class DetailsRouterMock: RouterMock, DetailsRouting {
    
    var routeToItemDetailsCallCount = 0
    
    func routeToItemDetails(item: ItemModel) {
        routeToItemDetailsCallCount += 1
    }
}

class DetailsViewModelMock: ViewModelMock, DetailsViewableModel {
    
    var setListenerCallCount = 0
    var presentItemCallCount = 0
    
    weak var listener: DetailsViewModelListener? {
        didSet {
            setListenerCallCount += 1
        }
    }
    
    func presentItem(item: ItemModel) {
        presentItemCallCount += 1
    }
}

class DetailsViewControllerMock: ViewControllableMock, DetailsViewControllable {
    
    var setImageURLCallCount = 0
    var setTitleTextCallCount = 0
    var setPriceTextCallCount = 0
    var setLocationTextCallCount = 0
    var setDescriptionTextCallCount = 0
    var setOptionalFeaturesCallCount = 0
    var setListenerCallCount = 0
    var showMoreCallCount = 0
    var showLessCallCount = 0
    
    var imageURL: URL? {
        didSet {
            setImageURLCallCount += 1
        }
    }
    
    var titleText: String? {
        didSet {
            setTitleTextCallCount += 1
        }
    }
    
    var priceText: String? {
        didSet {
            setPriceTextCallCount += 1
        }
    }
    
    var locationText: String? {
        didSet {
            setLocationTextCallCount += 1
        }
    }
    
    var descriptionText: String? {
        didSet {
            setDescriptionTextCallCount += 1
        }
    }
    
    var optionalFeatures: [String : String]? {
        didSet {
            setOptionalFeaturesCallCount += 1
        }
    }
    
    weak var listener: DetailsViewControllerListener? {
        didSet {
            setListenerCallCount += 1
        }
    }
    
    func showMore(moreHeight: CGFloat) {
        showMoreCallCount += 1
    }
    
    func showLess() {
        showLessCallCount += 1
    }
}

class DetailsViewModelListenerMock: DetailsViewModelListener {
    
    var wantToDetachCallCount = 0
    
    func wantToDetach() {
        wantToDetachCallCount += 1
    }
}

class DetailsViewControllerListenerMock: DetailsViewControllerListener {
    
    var didTapMoreLessButtonCallCount = 0
    var viewWillDisappearCallCount = 0
    var viewWillRotateCallCount = 0
    
    func didTapMoreLessButton() {
        didTapMoreLessButtonCallCount += 1
    }
    
    func viewWillDisappear() {
        viewWillDisappearCallCount += 1
    }
    
    func viewWillRotate(toSize size: CGSize) {
        viewWillRotateCallCount += 1
    }
}
