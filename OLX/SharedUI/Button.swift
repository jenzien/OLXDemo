//
//  Button.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {
    
    let theme: Theme
    
    init(theme: Theme = Themes.Default) {
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        setTitleColor(theme.primaryText, for: .normal)
        setTitleColor(theme.primaryText.withAlphaComponent(0.5), for: .highlighted)
        
        layer.borderColor = theme.secondaryColor.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
