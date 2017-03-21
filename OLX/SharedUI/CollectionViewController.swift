//
//  CollectionView.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, ViewControllable {
    
    let theme: Theme
    
    var viewController: UIViewController {
        return self
    }
    
    init(theme: Theme = Themes.Default, collectionViewLayout: UICollectionViewLayout) {
        self.theme = theme
        super.init(collectionViewLayout: collectionViewLayout)
        
        collectionView?.backgroundColor = theme.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
