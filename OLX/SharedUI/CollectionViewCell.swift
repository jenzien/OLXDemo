//
//  CollectionViewCell.swift
//  OLX
//
//  Created by Jake Enzien on 3/14/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let theme: Theme
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, theme: Themes.Default)
    }
    
    init(frame: CGRect = CGRect.zero, theme: Theme = Themes.Default) {
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        contentView.backgroundColor = theme.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
