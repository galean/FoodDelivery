//
//  RestaurantsTableViewCellDataModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit

class RestaurantsTableViewCellDataModel: NSObject {
    var data: RestaurantsTableViewCellData
    
    init(with data: RestaurantsTableViewCellData) {
        self.data = data
    }
}
