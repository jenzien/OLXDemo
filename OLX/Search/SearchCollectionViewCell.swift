//
//  SearchCollectionViewCell.swift
//  OLX
//
//  Created by Jake Enzien on 3/14/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class SearchCollectionViewCell: CollectionViewCell {
    
    static let defaultCellWidth: CGFloat = ceil((UIScreen.main.nativeBounds.size.width / UIScreen.main.scale - 3.0 * Constants.horizontalPadding) / 2.0)
    
    let title = Label(textStyle: .Subtitle)
    let price = Label(textStyle: .Title)
    let image = ImageView()
    var imageWidth: Int? = nil
    var imageHeight: Int? = nil
    
    init(frame: CGRect) {
        super.init(frame: CGRect.zero, theme: Themes.Default)
        
        addSubviews()
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(SearchCollectionViewCell.defaultCellWidth).priority(999)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        image.stopImageLoad()
        image.image = nil
        title.text = nil
        price.text = nil
    }
    
    func resize(defaultWidthHeight: CGFloat) {
        makeConstraints(defaultWidthHeight: defaultWidthHeight)
    }
    
    // MARK: - private
    func addSubviews() {
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(price)
        
        contentView.layer.cornerRadius = 2.0
        contentView.layer.shadowOffset = CGSize(width: -1, height: 3)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.5
        
        title.numberOfLines = 2
        price.numberOfLines = 2
        
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor.gray
        image.delayLoad = true
        
        image.snp.remakeConstraints { (make) in
            make.height.equalTo(SearchCollectionViewCell.defaultCellWidth).priority(999)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().priority(1000)
            make.bottom.equalTo(title.snp.top).offset(-Constants.verticalPadding)
        }
        
        title.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        title.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding).priority(999)
            make.trailing.equalToSuperview().offset(-Constants.horizontalParentPadding)
            make.bottom.equalTo(price.snp.top).offset(-Constants.verticalPadding)
        }
        
        price.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        price.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding).priority(999)
            make.trailing.equalToSuperview().offset(-Constants.horizontalParentPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }
    }
    
    private func makeConstraints(defaultWidthHeight: CGFloat) {
        var height: CGFloat = defaultWidthHeight
        
        if let imageWidth = imageWidth, let imageHeight = imageHeight {
            let aspect = CGFloat(imageHeight) / CGFloat(imageWidth)
            if aspect > 1.0 {
                height = height * aspect
            }
        }
        
        contentView.snp.updateConstraints { (make) in
            make.width.equalTo(defaultWidthHeight).priority(999)
        }
        image.snp.updateConstraints { (make) in
            make.height.equalTo(height).priority(999)
        }
    }
    
    struct Constants {
        static let horizontalParentPadding: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 8.0
        static let verticalPadding: CGFloat = 8.0
    }
}
