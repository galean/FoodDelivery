//
//  CityModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var version: Int = 0
    @objc dynamic var name: String = ""
    
    let restaurants = List<Restaurant>()
    
    static override func primaryKey() -> String {
        return "id"
    }
    
    static func fromCityStruct(_ cityStruct: CityStruct) -> City {
        let city = City()
        city.id = cityStruct.id
        city.version = cityStruct.version
        city.name = cityStruct.name
        return city
    }
}

struct CityStruct: Codable {
    let id: Int
    let version: Int
    let name: String
}

struct CityRespData {
    let city: CityStruct
}

struct CitiesRespData: Codable {
    let cities: [CityStruct]
}
