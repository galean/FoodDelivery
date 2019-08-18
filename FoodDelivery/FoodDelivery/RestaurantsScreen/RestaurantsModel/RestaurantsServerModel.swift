//
//  RestaurantsServerModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 18.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

protocol RestaurantsServerModelProtocol {
    var delegate: RestaurantsServerModelDelegate? { get set }
    func requestRestaurants(forCity cityID: Int, version: Int?)
}

protocol RestaurantsServerModelDelegate {
    func restaurantsResponse(_ responseData: RestaurantsRespData?, error: NSError?)
}

class RestaurantsServerModel: NSObject {
    var delegate: RestaurantsServerModelDelegate?
    #if DEBUG
    let serverModel: ServerModelProtocol = ServerModelMock()
    #else
    let serverModel: ServerModelProtocol = ServerModel()
    #endif
}

extension RestaurantsServerModel: RestaurantsServerModelProtocol {
    func requestRestaurants(forCity cityID: Int, version: Int?) {
        serverModel.requestRestaurants(forCity: cityID, version: version) {
            (responseData, error) in
            self.delegate?.restaurantsResponse(responseData, error: error)
        }
    }
}
