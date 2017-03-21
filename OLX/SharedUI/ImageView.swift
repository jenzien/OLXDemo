//
//  ImageView.swift
//  OLX
//
//  Created by Jake Enzien on 3/14/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit

class ImageView: UIImageView {
    
    var delayLoad = false
    var imageURL: URL? {
        didSet {
            imageLoaded = false
            if !delayLoad {
                loadImage()
            }
        }
    }
    private var imageLoaded = false
    
    convenience init(imageName: String) {
        self.init()
        
        image = Image(named: imageName)
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startImageLoad() {
        loadImage()
    }
    
    func stopImageLoad() {
        af_cancelImageRequest()
    }
    
    // MARK: - private
    private func loadImage() {
        guard let url = imageURL, !imageLoaded else {
            return
        }
        af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(1), runImageTransitionIfCached: true, completion: { [weak self] (response) in
            self?.imageLoaded = true
        })
    }
}
