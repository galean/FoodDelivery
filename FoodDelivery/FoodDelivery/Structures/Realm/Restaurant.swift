//
//  RestaurantsModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import RealmSwift

struct RestaurantsRespData: Codable {
    let city: CityStruct
    let restaurants: [RestaurantStruct]
}

struct RestaurantStruct: Codable {
    let id: Int
    let version: Int
    let city: String
    let name: String
    let image_data_url_string: String
    let price: Int?
    let delivery: Float?
    let rating: Int?
    let categories: String?
    let sections: [SectionStruct]
}

class Restaurant: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var version: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image_data_url_string: String = ""
    let price = RealmOptional<Int>()
    let delivery = RealmOptional<Float>()
    let rating = RealmOptional<Int>()
    @objc dynamic var categories: String?
    let sections = List<Section>()
    
    @objc dynamic var about_us: String?
  //  let dishes = List<Dish>() it would be added later
    
    let ofCity = LinkingObjects(fromType: City.self,
                                property: "restaurants")
    
    static override func primaryKey() -> String {
        return "id"
    }
    
    func toStruct() -> RestaurantStruct {
        let cityName = ofCity.first!.name
        var sectionStructs = [SectionStruct]()
        for section in sections {
            sectionStructs.append(section.toStruct())
        }
        let restStruct = RestaurantStruct(id: id, version: version,
                                          city: cityName, name: name,
                                          image_data_url_string: image_data_url_string,
                                          price: price.value,
                                          delivery: delivery.value,
                                          rating: rating.value,
                                          categories: categories,
                                          sections: sectionStructs)
        return restStruct
    }
    
    static func fromRestaurantStruct(_ restaurantStruct: RestaurantStruct) -> Restaurant {
        let restaurant = Restaurant()
        restaurant.version = restaurantStruct.version
        restaurant.id = restaurantStruct.id
        restaurant.name = restaurantStruct.name
        restaurant.image_data_url_string = restaurantStruct.image_data_url_string
        restaurant.price.value = restaurantStruct.price
        restaurant.delivery.value = restaurantStruct.delivery
        restaurant.rating.value = restaurantStruct.rating
        restaurant.categories = restaurantStruct.categories
        
        for sectionStruct in restaurantStruct.sections {
            let section = Section.fromSectionStruct(sectionStruct)
            restaurant.sections.append(section)
        }
        
        return restaurant
    }
}
