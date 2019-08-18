//
//  CityPickerProtocols.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 17.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit

protocol RestaurantsToCityPickerProtocol: NSObject {
    var delegate: CityPickerToRestaurantsProtocol? { get set }
    func setCurrentCity(_ currentCity: String)
}

protocol CityPickerToRestaurantsProtocol: NSObject {
    func pickedCity()
}

