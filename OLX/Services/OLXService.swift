//
//  OLXService.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol OLXServicing: Servicing {
    func getItems(location: String, searchTerm: String, pageSize: Int?, offset: Int?, completion: @escaping (ItemsModel?, Error?)->())
}

class OLXService: Service, OLXServicing {
    func getItems(location: String, searchTerm: String, pageSize: Int?, offset: Int?, completion: @escaping (ItemsModel?, Error?)->()) {
        guard let url = URL(string: "https://api-v2.olx.com/items") else {
            return
        }
        
        var params = [
            "location": location,
            "searchTerm": searchTerm,
        ]
        
        if let pageSize = pageSize {
            let pageSizeString = String(describing: pageSize)
            params["pageSize"] = pageSizeString
        }
        
        if let offset = offset {
            let offsetString = String(describing: offset)
            params["offset"] = offsetString
        }
        
        networkEngine.enqueue(url: url, params: params, forceCache: true) { (itemsModel: ItemsModel?, error: Error?) in
            completion(itemsModel, error)
        }
    }

}
