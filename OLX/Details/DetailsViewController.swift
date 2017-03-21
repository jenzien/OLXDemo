//
//  DetailsViewController.swift
//  OLX
//
//  Created by Jake Enzien on 3/15/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsViewControllable: ViewControllable {
    var imageURL: URL? { get set }
    var titleText: String? { get set }
    var priceText: String? { get set }
    var locationText: String? { get set }
    var descriptionText: String? { get set }
    var optionalFeatures: [String: String]? { get set }
    
    weak var listener: DetailsViewControllerListener? { get set }
    
    func showMore(moreHeight: CGFloat)
    func showLess()
}

protocol DetailsViewControllerListener: class {
    func didTapMoreLessButton()
    func viewWillDisappear()
    func viewWillRotate(toSize size: CGSize)
}

final class DetailsViewController: ViewController, DetailsViewControllable {
    
    weak var listener: DetailsViewControllerListener?
    
    private let titleLabel = Label(theme: Themes.Dark, textStyle: .Title)
    private let priceLabel = Label(theme: Themes.Dark, textStyle: .TitleBold)
    private let image = ImageView()
    private let descriptionLabel = Label(theme: Themes.Dark, textStyle: .Subtitle)
    private let overlayView = View(theme: Themes.Dark)
    private let imageViewContainer = View(theme: Themes.Dark)
    
    private let infoView = ScrollView(theme: Themes.Dark)
    private let locationPin = ImageView(imageName: "LocationPin")
    private let locationLabel = Label(theme: Themes.Dark, textStyle: .Subtitle)
    private let moreButton = Button(theme: Themes.Dark)
    private let lineView = View()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    var item: ItemModel? = nil
    
    var imageURL: URL? {
        didSet {
            image.imageURL = imageURL
        }
    }
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var priceText: String? {
        didSet {
            priceLabel.text = priceText
        }
    }
    
    var locationText: String? {
        didSet {
            locationLabel.text = locationText
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    var optionalFeatures: [String : String]? {
        didSet {
            setupInfoView()
        }
    }
    
    init() {
        super.init()

        addSubviews()
        makeConstraints()
        
        setupImageViewContainer()
        setupOverlayView()
        
        edgesForExtendedLayout = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.isNavigationBarHidden = false
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            listener?.viewWillDisappear()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        listener?.viewWillRotate(toSize: size)
    }
    
    func didTapMore() {
        listener?.didTapMoreLessButton()
    }
    
    // MARK: - DetailsViewControllable
    
    func showMore(moreHeight: CGFloat) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: { [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            self.blurView.snp.updateConstraints { (make) in
                make.height.equalTo(moreHeight)
            }
            
            self.overlayView.setNeedsUpdateConstraints()
            self.overlayView.layoutIfNeeded()
            self.moreButton.setTitle(OLXStrings.lessButtonTitle(), for: .normal)
        }, completion: nil)
    }
    
    func showLess() {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: { [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            self.blurView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            
            self.overlayView.setNeedsUpdateConstraints()
            self.overlayView.layoutIfNeeded()
            self.moreButton.setTitle(OLXStrings.moreButtonTitle(), for: .normal)
        }, completion: nil)
    }
    
    // MARK: - private
    private func addSubviews() {
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        
        image.contentMode = .scaleAspectFit
        
        overlayView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        
        view.addSubview(imageViewContainer)
        view.addSubview(overlayView)
    }
    
    private func makeConstraints() {
        imageViewContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        overlayView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
    
    private func setupImageViewContainer() {
        imageViewContainer.addSubview(image)
        
        image.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupOverlayView() {
        overlayView.addSubview(titleLabel)
        overlayView.addSubview(priceLabel)
        overlayView.addSubview(locationPin)
        overlayView.addSubview(locationLabel)
        overlayView.addSubview(moreButton)
        overlayView.addSubview(lineView)
        overlayView.addSubview(blurView)
        overlayView.clipsToBounds = false
        locationPin.tintColor = theme.primaryColor
        
        moreButton.setTitle(OLXStrings.moreButtonTitle(), for: .normal)
        moreButton.contentEdgeInsets = UIEdgeInsetsMake(0, Constants.horizontalPadding, 0, Constants.horizontalPadding)
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        moreButton.accessibilityIdentifier = AccessibilityIdentifiers.detailsViewMoreButton.rawValue
        
        blurView.contentView.addSubview(infoView)
        infoView.backgroundColor = UIColor.clear
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.leading.trailing.equalTo(Constants.horizontalPadding)
            make.bottom.equalTo(priceLabel.snp.top).offset(-Constants.verticalPadding)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(Constants.horizontalPadding)
        }
        
        locationPin.snp.makeConstraints { (make) in
            make.leading.equalTo(Constants.horizontalPadding)
            make.trailing.equalTo(locationLabel.snp.leading).offset(-Constants.horizontalPadding)
            make.bottom.equalTo(lineView.snp.top).offset(-Constants.horizontalPadding)
            make.width.equalTo(Constants.pinWidth)
            make.height.equalTo(Constants.pinHeight)
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-Constants.horizontalPadding)
            make.bottom.equalTo(lineView.snp.top).offset(-Constants.horizontalPadding)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(lineView.snp.top).offset(-Constants.verticalPadding)
            make.trailing.equalTo(-Constants.horizontalPadding)
            make.height.equalTo(Constants.buttonHeight)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(Constants.horizontalPadding)
            make.trailing.equalTo(-Constants.horizontalPadding)
            make.bottom.equalTo(blurView.snp.top).offset(-Constants.verticalPadding)
            make.height.equalTo(Constants.lineHeight)
        }
        
        blurView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    private func setupInfoView() {
        infoView.subviews.forEach({$0.removeFromSuperview()})
        
        guard let optionalFeatures = optionalFeatures else {
            return
        }
        
        infoView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(Constants.verticalPadding)
            make.leading.equalTo(Constants.horizontalPadding)
            make.trailing.equalTo(-Constants.horizontalPadding)
            make.width.equalToSuperview().offset(-Constants.horizontalPadding * 2)
        }
        
        let line = View()
        line.backgroundColor = UIColor.white
        infoView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.verticalPadding)
            make.leading.equalTo(Constants.horizontalPadding)
            make.trailing.equalTo(-Constants.horizontalPadding)
            make.width.equalToSuperview().offset(-Constants.horizontalPadding * 2)
            make.height.equalTo(1)
        }
        
        var previousNameView: UIView = line
        var previousValueView: UIView? = nil
        
        for (name, value) in optionalFeatures {
            let nameLabel = Label(theme: Themes.Dark, textStyle: .Subtitle)
            let valueLabel = Label(theme: Themes.Dark, textStyle: .Subtitle)
            
            nameLabel.text = name
            valueLabel.text = value
            
            infoView.addSubview(nameLabel)
            infoView.addSubview(valueLabel)
            
            nameLabel.snp.makeConstraints({ (make) in
                make.leading.equalTo(Constants.horizontalPadding)
                make.trailing.lessThanOrEqualTo(valueLabel.snp.leading).offset(-Constants.horizontalPadding)
                make.top.equalTo(previousNameView.snp.bottom).offset(Constants.verticalPadding)
            })
            
            valueLabel.snp.makeConstraints({ (make) in
                if let previousValueView = previousValueView {
                    make.leading.equalTo(previousValueView.snp.leading)
                }
                make.top.equalTo(previousNameView.snp.bottom).offset(Constants.verticalPadding)
                make.bottom.equalTo(nameLabel.snp.bottom)
            })
            previousNameView = nameLabel
            previousValueView = valueLabel
        }
        
    }
    
    struct Constants {
        static let horizontalPadding: CGFloat = 8.0
        static let verticalPadding: CGFloat = 8.0
        
        static let buttonHeight: CGFloat = 35.0
        
        static let lineHeight: CGFloat = 2.0
        static let bottomPadding: CGFloat = 16.0
        
        static let pinHeight: CGFloat = 33.0
        static let pinWidth: CGFloat = 22.0
    }
    
}
