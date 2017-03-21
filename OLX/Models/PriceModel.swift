//
//  PriceModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import Freddy

struct PriceModel: JSONDecodable {
    let amount: Int
    let displayPrice: String
    
    init (amount: Int,
          displayPrice: String) {
        self.amount = amount
        self.displayPrice = displayPrice
    }
    
    init(json: JSON) throws {
        amount = try json.getInt(at: "amount")
        displayPrice = try json.getString(at: "displayPrice")
    }
}
