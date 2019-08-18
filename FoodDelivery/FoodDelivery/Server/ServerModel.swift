//
//  ServerModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 17.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

typealias DefaultCityCompletion = (_ responseData: CityRespData?, _ error: NSError?) -> Void
typealias RestaurantsCompletion = (_ responseData: RestaurantsRespData?, _ error: NSError?) -> Void
typealias CitiesCompletion = (_ responseData: CitiesRespData?, _ error: NSError?) -> Void

protocol ServerModelProtocol: NSObject {
    func requestDefaultCity(_ completion: @escaping DefaultCityCompletion)
    func requestRestaurants(forCity cityID: Int, version: Int?,
                            _ completion: @escaping RestaurantsCompletion)
    func requestCities(_ completion: @escaping CitiesCompletion)
}

class ServerModel: NSObject {
    
}

extension ServerModel: ServerModelProtocol {
    func requestDefaultCity(_ completion: @escaping DefaultCityCompletion) {
        
    }
    
    func requestRestaurants(forCity cityID: Int, version: Int?, _ completion: @escaping RestaurantsCompletion) {
        
    }
    
    func requestCities(_ completion: @escaping CitiesCompletion) {
        
    }
}


