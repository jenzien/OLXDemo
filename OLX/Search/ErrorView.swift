//
//  ErrorView.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

final class ErrorView: View {
    
    let errorLabel = Label(textStyle: .Subtitle)
    var tapHandler: (() -> ())?
    
    private let errorImage = ImageView(imageName: "ErrorImage")
    private let tryAgainButton = Button()
    
    init() {
        super.init()
        
        backgroundColor = UIColor.lightGray
        
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapTryAgainButton() {
        tapHandler?()
    }
    
    // MARK: - private
    
    private func addSubviews() {
        addSubview(errorImage)
        addSubview(errorLabel)
        addSubview(tryAgainButton)
        
        errorLabel.textAlignment = .center
        tryAgainButton.setTitle(OLXStrings.tryAgain(), for: .normal)
        tryAgainButton.setTitleColor(UIColor.black, for: .normal)
        tryAgainButton.contentEdgeInsets = UIEdgeInsetsMake(0, Constants.horizontalPadding, 0, Constants.horizontalPadding)
        tryAgainButton.addTarget(self, action: #selector(didTapTryAgainButton), for: .touchUpInside)
        
        errorImage.snp.makeConstraints { (make) in
            make.width.equalTo(Constants.imageWidth)
            make.height.equalTo(Constants.imageHeight)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.bottom.equalTo(errorLabel.snp.top).offset(-Constants.verticalPadding)
        }
        
        errorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(Constants.horizontalPadding)
            make.trailing.equalTo(-Constants.verticalPadding)
            make.bottom.equalTo(tryAgainButton.snp.top).offset(-Constants.verticalPadding)
        }
        
        tryAgainButton.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.buttonHeight)
            make.centerX.equalToSuperview()
        }
        
    }
    
    struct Constants {
        static let imageWidth: CGFloat = 122.0
        static let imageHeight: CGFloat = 102.0
        
        static let horizontalPadding: CGFloat = 8.0
        static let verticalPadding: CGFloat = 8.0
        
        static let buttonHeight: CGFloat = 44.0
    }
}
