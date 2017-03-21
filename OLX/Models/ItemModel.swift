//
//  ItemsModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import Freddy

struct ItemModel: JSONDecodable {
    let description: String
    let displayLocation: String
    let mediumImage: String
    let fullImage: String
    let thumbnail: String
    let imageWidth: Int?
    let imageHeight: Int?
    let title: String
    let price: PriceModel?
    let optionals: [OptionalModel]?
    
    init(description: String,
         displayLocation: String,
         mediumImage: String,
         fullImage: String,
         thumbnail: String,
         imageWidth: Int?,
         imageHeight: Int?,
         title: String,
         price: PriceModel?,
         optionals: [OptionalModel]?) {
        self.description = description
        self.displayLocation = displayLocation
        self.mediumImage = mediumImage
        self.fullImage = fullImage
        self.thumbnail = thumbnail
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.title = title
        self.price = price
        self.optionals = optionals
    }
    
    init(json: JSON) throws {
        description = try json.getString(at: "description", or: "")
        displayLocation = try json.getString(at: "displayLocation", or: "")
        mediumImage = try json.getString(at: "mediumImage", or: "")
        fullImage = try json.getString(at: "fullImage", or: "")
        thumbnail = try json.getString(at: "thumbnail", or: "")
        imageWidth = try json.getInt(at: "imageWidth", alongPath: [.MissingKeyBecomesNil, .NullBecomesNil])
        imageHeight = try json.getInt(at: "imageHeight", alongPath: [.MissingKeyBecomesNil, .NullBecomesNil]    )
        title = try json.getString(at: "title", or: "")
        
        do {
            let _ = try json.getDictionary(at: "price")
            let amount = try json.getInt(at: "price", "amount", or: 0)
            let displayPrice = try json.getString(at: "price", "displayPrice", or: "")
            price = PriceModel(amount: amount, displayPrice: displayPrice)
        } catch {
            price = nil
        }
        
        do {
            let optionalList = try json.getArray(at: "optionals")
            optionals = try optionalList.map({ try OptionalModel(json: $0) })
        } catch {
            optionals = nil
        }
    }
}
