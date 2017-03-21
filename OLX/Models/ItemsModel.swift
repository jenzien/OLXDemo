//
//  ItemsModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import Freddy

struct ItemsModel: JSONDecodable {
    let items: [ItemModel]
    let total: Int
    
    init(items: [ItemModel],
         total: Int) {
        self.items = items
        self.total = total
    }
    
    init(json: JSON) throws {
        items = try json.getArray(at: "data").map(ItemModel.init)
        total = try json.getInt(at: "metadata", "total", or: 0)
    }
}
