//
//  RestaurantsTableViewCellData.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

struct RestaurantsTableViewCellData {
    let name: String
    let imageDataUrlString: String
    let price: Int?
    let delivery: Float?
    let rating: Int?
    let categories: String?
    
    init(with restStruct: RestaurantStruct) {
        self.name = restStruct.name
        self.imageDataUrlString = restStruct.image_data_url_string
        self.price = restStruct.price
        self.delivery = restStruct.delivery
        self.rating = restStruct.rating
        self.categories = restStruct.categories
    }
}
