//
//  View.swift
//  OLX
//
//  Created by Jake Enzien on 3/16/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

class View: UIView {
    
    let theme: Theme
    
    init(theme: Theme = Themes.Default) {
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = theme.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
