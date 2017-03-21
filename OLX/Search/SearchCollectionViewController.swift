//
//  SearchCollectionViewController.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import CHTCollectionViewWaterfallLayout
import Foundation
import SnapKit
import UIKit

protocol SearchCollectionViewControllable: ViewControllable {
    weak var listener: SearchCollectionViewControllerListener? { get set }
    var items: [ItemModel] { get set }
    
    func showSearchResultsCount(totalResults: Int)
    func showErrorView(errorMessage: String)
    func hideErrorView()
}

protocol SearchCollectionViewControllerListener: class {
    func searchBarDidSearch(forText search: String)
    func scrollViewDidScrollToBottom()
    func didSelectItem(item: ItemModel)
    func refreshData()
    func viewWillDisappear()
}

final class SearchCollectionViewController: CollectionViewController, SearchCollectionViewControllable, UISearchBarDelegate, CHTCollectionViewDelegateWaterfallLayout {
    
    weak var listener: SearchCollectionViewControllerListener?
    
    private let cellIdentifier = "SearchCell"
    private let flowLayout = CHTCollectionViewWaterfallLayout()
    private let searchController = UISearchController(searchResultsController: nil)
    private var cellWidth: CGFloat
    private let sizingCell = SearchCollectionViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: SearchCollectionViewCell.defaultCellWidth, height: SearchCollectionViewCell.defaultCellWidth)))
    private let backgroundView = UIView()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    private let errorView = ErrorView()
    private var viewDidAppear = false
    private var isUpdating = false {
        didSet {
            if !isUpdating {
                refreshControl.endRefreshing()
                activityIndicator.stopAnimating()
            }
        }
    }
    
    var items: [ItemModel] = [] {
        didSet {
            if !viewDidAppear {
                return
            }
            
            if oldValue.count > items.count {
                UIView.animate(withDuration: 3.0, animations: { [weak self] in
                    self?.flowLayout.columnCount = Int(UIScreen.main.bounds.size.width / SearchCollectionViewCell.defaultCellWidth)
                    self?.collectionView?.reloadData()
                    self?.flowLayout.invalidateLayout()
                    self?.updateVisibleCells()
                })
            } else {
                if !isUpdating {
                    isUpdating = true
                    collectionView?.performBatchUpdates( { [weak self] in
                        guard let `self` = self else {
                            return
                        }
                        
                        let start = oldValue.count
                        let end = self.items.count
                        
                        let paths = Array(start..<end).map({ IndexPath(row: $0, section: 0) })
                        self.collectionView?.insertItems(at: paths)
                    }, completion: { [weak self] (completed) in
                        self?.isUpdating = false
                        self?.updateVisibleCells()
                    })
                }
            }
        }
    }
    
    init(theme: Theme = DefaultTheme()) {
        cellWidth = SearchCollectionViewCell.defaultCellWidth
        
        super.init(theme: theme, collectionViewLayout: flowLayout)
        
        setupLayout()
        
        searchController.searchBar.delegate = self
        collectionView?.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        backgroundView.backgroundColor = UIColor.clear
        collectionView?.backgroundView = backgroundView
        backgroundView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        backgroundView.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        errorView.tapHandler = { [weak self] in
            self?.listener?.refreshData()
        }
        errorView.isHidden = true
        activityIndicator.color = UIColor.gray
        
        collectionView?.accessibilityIdentifier = AccessibilityIdentifiers.searchViewController.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = theme.accentColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.accessibilityIdentifier = AccessibilityIdentifiers.navigationBar.rawValue
        
        viewDidAppear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDidAppear = false
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            listener?.viewWillDisappear()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        flowLayout.columnCount = Int(size.width / SearchCollectionViewCell.defaultCellWidth)
        let countFloat = CGFloat(flowLayout.columnCount)
        cellWidth = (size.width - Constants.padding * (countFloat + 1)) / countFloat
        coordinator.animate(alongsideTransition: nil) { [weak self] (context) in
            guard let collectionView = self?.collectionView else {
                return
            }
            
            if collectionView.contentOffset.y + collectionView.frame.size.height > collectionView.contentSize.height {
                let yOffset = collectionView.contentSize.height - collectionView.frame.size.height
                collectionView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            }
            self?.updateVisibleCells()
        }
    }
    
    // MARK: - SearchCollectionViewControllable
    
    func showSearchResultsCount(totalResults: Int) {
        navigationItem.titleView = nil
        navigationItem.title = resultsString(totalResults: totalResults)
    }
    
    func showErrorView(errorMessage: String) {
        if !errorView.isHidden {
            return
        }
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.errorView.errorLabel.text = errorMessage
            self?.errorView.isHidden = false
            self?.errorView.alpha = 1.0
        }
    }
    
    func hideErrorView() {
        if errorView.isHidden {
            return
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.errorView.errorLabel.text = nil
            self?.errorView.isHidden = true
            self?.errorView.alpha = 0.0
        }
    }
    
    // MARK: - UIRefreshControl
    
    func refreshData() {
        if refreshControl.isRefreshing {
            listener?.refreshData()
        }
    }
 
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let cell = cell as? SearchCollectionViewCell {
            let item = items[indexPath.row]
            cell.title.text = item.title
            cell.price.text = item.price?.displayPrice
            cell.image.imageURL = URL(string: item.fullImage)
            cell.imageWidth = item.imageWidth
            cell.imageHeight = item.imageHeight
            cell.resize(defaultWidthHeight: cellWidth)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < items.count else {
            return
        }
        
        listener?.didSelectItem(item: items[indexPath.row])
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text {
            listener?.searchBarDidSearch(forText: search)
        }
    }
    
    // MARK: - CHTCollectionViewDelegateWaterfallLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = items[indexPath.row]
        sizingCell.title.text = item.title
        sizingCell.price.text = item.price?.displayPrice
        sizingCell.imageWidth = item.imageWidth
        sizingCell.imageHeight = item.imageHeight
        sizingCell.resize(defaultWidthHeight: cellWidth)
        let size = sizingCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return size
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let overscroll = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height
        if overscroll > 0 && scrollView.contentSize.height > 0 {
            startActivityIndicator()
            let offset = min(overscroll, Constants.activityIndicatorSize + Constants.activityIndicatorPadding)
            activityIndicator.snp.updateConstraints({ (make) in
                make.top.equalTo(backgroundView.snp.bottom).offset(-offset)
            })
        } else {
            stopActivityIndicator()
            activityIndicator.snp.updateConstraints({ (make) in
                make.top.equalTo(backgroundView.snp.bottom)
            })
        }
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        flowLayout.invalidateLayout()
        updateVisibleCells()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateVisibleCells()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let maxY = scrollView.contentSize.height - scrollView.frame.size.height * 1.5
        if scrollView.contentOffset.y >=  maxY && !isUpdating {
            listener?.scrollViewDidScrollToBottom()
        }
        
        updateVisibleCells()
    }
    
    // MARK: - private
    
    private func updateVisibleCells() {
        collectionView?.visibleCells.forEach { (cell) in
            if let cell = cell as? SearchCollectionViewCell {
                cell.image.startImageLoad()
            }
        }
    }
    
    private func setupLayout() {
        collectionView?.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.backgroundColor = UIColor.lightGray

        flowLayout.minimumColumnSpacing = Constants.padding
        flowLayout.minimumInteritemSpacing = Constants.padding
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, Constants.padding, 0.0, Constants.padding)
        flowLayout.columnCount = Int(UIScreen.main.bounds.size.width / cellWidth)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = Colors.olxDarkGreen
        searchController.searchBar.tintColor = Colors.olxDarkGreen
        
        if navigationItem.title == nil {
            navigationItem.titleView = searchController.searchBar
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func resultsString(totalResults: Int) -> String {
        return String("\(totalResults) \(OLXStrings.resultsString())")
    }
    
    struct Constants {
        static let padding: CGFloat = 8.0
        
        static let activityIndicatorSize: CGFloat = 40.0
        static let activityIndicatorPadding: CGFloat = 20.0
    }
}
