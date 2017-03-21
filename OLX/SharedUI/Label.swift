//
//  Label.swift
//  OLX
//
//  Created by Jake Enzien on 3/14/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

enum TextStyle {
    case Title
    case TitleBold
    case Subtitle
    case Heading
    case Heading2
    case Heading3
}

class Label: UILabel {
    
    let theme: Theme
    let textStyle: TextStyle 
    
    init(theme: Theme = Themes.Default, textStyle: TextStyle) {
        self.theme = theme
        self.textStyle = textStyle
        super.init(frame: CGRect.zero)
        
        setTextStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private
    func setTextStyle() {
        var fontSize: CGFloat = 0 
        var fontWeight = UIFontWeightRegular
        
        switch textStyle {
        case .Title, .TitleBold:
            fontSize = 16
        case .Subtitle:
            fontSize = 13
        case .Heading:
            fontSize = 12
        case .Heading2:
            fontSize = 9
        case .Heading3:
            fontSize = 8
        }
        
        switch textStyle {
        case .Title, .Subtitle:
            fontWeight = UIFontWeightMedium
        case .TitleBold:
            fontWeight = UIFontWeightBold
        default:
            fontWeight = UIFontWeightRegular
        }
        
        font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        textColor = theme.primaryText
    }
}
