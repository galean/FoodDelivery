//
//  ServerModelMock.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 17.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation


class ServerModelMock: NSObject {    
    lazy var restaurantsBuilder: RestaurantBuilder = {
       return RestaurantBuilder()
    }()
    
    lazy var cityBuilder: CityBuilder = {
        return CityBuilder()
    }()
}

extension ServerModelMock {
    func internalRequestDefaultCity(_ completion: @escaping DefaultCityCompletion ) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
            let city = self.getDefaultCity()
            completion(city, nil)
        }
    }
    
    func getDefaultCity() -> CityRespData {
        let cityStruct = cityBuilder.kyiv
        let cityRespData = CityRespData(city: cityStruct)
        return cityRespData
    }
}

extension ServerModelMock {
    func internalRequestRestaurants(forCity cityID: Int, version: Int?,
                                    _ completion: @escaping RestaurantsCompletion) {
        let cityForID = cityBuilder.city(forID: cityID)
        guard let city = cityForID else {
            completion(nil, NSError(domain: "GP.FoodDelivery", code: 2, userInfo: nil))
            return
        }
        
        if version == nil || version! < city.version {
            if city.name == "Kyiv" {
                DispatchQueue.global().asyncAfter(deadline: .now()+2) {
                    let kyivRest = self.getKyivRestaurants()
                    let respData = RestaurantsRespData(city: kyivRest.kyiv,
                                                       restaurants: kyivRest.restaurants)
                    completion(respData, nil)
                }
            } else if city.name == "Odesa" {
                DispatchQueue.global().asyncAfter(deadline: .now()+2) {
                    let odesaRest = self.getOdesaRestaurants()
                    let respData = RestaurantsRespData(city: odesaRest.odesa,
                                                       restaurants: odesaRest.restaurants)
                    completion(respData, nil)
                }
            } else {
                completion(nil, nil)
            }
            return
        }
        
        completion(nil, nil)
    }
    
    func getKyivRestaurants() -> (kyiv: CityStruct, restaurants: [RestaurantStruct]) {
        let kyiv = cityBuilder.kyiv
        let restaurants = restaurantsBuilder.kyivRestaurants
        return (kyiv, restaurants)
    }
    
    func getOdesaRestaurants() -> (odesa: CityStruct, restaurants: [RestaurantStruct]) {
        let odesa = cityBuilder.odesa
        let restaurants = restaurantsBuilder.odessaRestaurants
        return (odesa, restaurants)
    }
}

extension ServerModelMock {
    func internalRequestCities(_ completion: @escaping CitiesCompletion ) {
        DispatchQueue.global().asyncAfter(deadline: .now()+2) {
            let citiesResp = self.getCities()
            completion(citiesResp, nil)
        }
    }
    func getCities() -> CitiesRespData {
        let cities = cityBuilder.allCities
        let respData = CitiesRespData(cities: cities)
        return respData
    }
}

extension ServerModelMock: ServerModelProtocol {
    func requestDefaultCity(_ completion: @escaping DefaultCityCompletion) {
        internalRequestDefaultCity(completion)
    }
    
    func requestRestaurants(forCity cityID: Int, version: Int?, _ completion: @escaping RestaurantsCompletion) {
        internalRequestRestaurants(forCity: cityID, version: version, completion)
    }
    
    func requestCities(_ completion: @escaping CitiesCompletion) {
        internalRequestCities(completion)
    }
}

class CityBuilder: NSObject {
    lazy var allCities: [CityStruct] = {
       return [odesa, kyiv]
    }()
    
    lazy var odesa: CityStruct = {
        return CityStruct(id: 1, version: 1, name: "Odesa")
    }()
    
    lazy var kyiv: CityStruct = {
        return CityStruct(id: 2, version: 1, name: "Kyiv")
    }()
    
    func city(forID id: Int) -> CityStruct? {
        var foundCity: CityStruct? = nil
        for city in allCities {
            if city.id == id {
                foundCity = city
                break
            }
        }
        
        return foundCity
    }
}

class SectionsBuilder: NSObject {
    lazy var newSection: SectionStruct = {
        return SectionStruct(id: 1, version: 1, name: "New")
    }()
    
    lazy var popularSection: SectionStruct = {
        return SectionStruct(id: 2, version: 1, name: "Popular")
    }()
    
    lazy var pizzaSection: SectionStruct = {
        return SectionStruct(id: 3, version: 1, name: "Pizza")
    }()
    
    lazy var sushiSection: SectionStruct = {
        return SectionStruct(id: 4, version: 1, name: "Sushi")
    }()
    
    lazy var allSections: [SectionStruct] = {
        return [newSection, popularSection, pizzaSection, sushiSection]
    }()
}

class RestaurantBuilder: NSObject {
    let sectionsBuilder = SectionsBuilder()
    
    lazy var odessaRestaurants: [RestaurantStruct] = {
        return [osava, starPizza, olio, dominosOdesa]
    }()
    
    lazy var kyivRestaurants: [RestaurantStruct] = {
        return [mafia, pizzaHouse, papaJohn, dominosKyiv]
    }()
    
    lazy var osava: RestaurantStruct = {
        let categories = "Sushi, Pizza, Business Lunch, Meat, Vegeterian"
        let sections: [SectionStruct] = [sectionsBuilder.popularSection, sectionsBuilder.sushiSection, sectionsBuilder.pizzaSection]
        let osava = createRestaurant(id: 1, version: 1, city: "Odesa", name: "Osava",
                                     imageDataUrlString: "", price: 200, delivery: 2, rating: 5,
                                     categories: categories, sections: sections)
        return osava
    }()
    
    lazy var starPizza: RestaurantStruct = {
        let categories = "Pizza, Business Lunch, Meat, Burgers"
        let sections: [SectionStruct] = [sectionsBuilder.popularSection, sectionsBuilder.pizzaSection]
        let osava = createRestaurant(id: 2, version: 1, city: "Odesa", name: "Star Pizza",
                                     imageDataUrlString: "", price: 150, delivery: 1, rating: 4,
                                     categories: categories, sections: sections)
        return osava
    }()

    lazy var olio: RestaurantStruct = {
        let categories = "Pizza, Business Lunch, Meat, Vegeterian"
        let sections: [SectionStruct] = [sectionsBuilder.newSection, sectionsBuilder.pizzaSection]
        let osava = createRestaurant(id: 3, version: 1, city: "Odesa", name: "Olio Pizza",
                                     imageDataUrlString: "", price: 150, delivery: 1.5, rating: 4,
                                     categories: categories, sections: sections)
        return osava
    }()
    
    lazy var mafia: RestaurantStruct = {
        let categories = "Sushi, Pizza, Meat"
        let sections: [SectionStruct] = [sectionsBuilder.popularSection, sectionsBuilder.sushiSection, sectionsBuilder.pizzaSection]
        let mafia = createRestaurant(id: 4, version: 1, city: "Kyiv", name: "Mafia",
                                     imageDataUrlString: "", price: 300, delivery: 2, rating: 3,
                                     categories: categories, sections: sections)
        return mafia
    }()
    
    lazy var pizzaHouse: RestaurantStruct = {
        let categories = "Sushi, Pizza, Meat, Business Lunch"
        let sections: [SectionStruct] = [sectionsBuilder.popularSection, sectionsBuilder.sushiSection, sectionsBuilder.pizzaSection]
        let pizzaHouse = createRestaurant(id: 5, version: 1, city: "Kyiv", name: "Pizza House",
                                     imageDataUrlString: "", price: 150, delivery: 1.5, rating: 4,
                                     categories: categories, sections: sections)
        return pizzaHouse
    }()
    
    lazy var papaJohn: RestaurantStruct = {
        let categories = "Pizza, Burgers, Business Lunch"
        let sections: [SectionStruct] = [sectionsBuilder.newSection, sectionsBuilder.pizzaSection]
        let papaJohn = createRestaurant(id: 6, version: 1, city: "Kyiv", name: "Papa John",
                                     imageDataUrlString: "", price: 200, delivery: 1.5, rating: 5,
                                     categories: categories, sections: sections)
        return papaJohn
    }()
    
    lazy var dominosKyiv: RestaurantStruct = {
        let categories = "Pizza"
        let sections: [SectionStruct] = [sectionsBuilder.newSection, sectionsBuilder.popularSection, sectionsBuilder.pizzaSection]
        let dominos = createRestaurant(id: 7, version: 1, city: "Kyiv", name: "Dominos",
                                     imageDataUrlString: "", price: 250, delivery: 0.5, rating: 5,
                                     categories: categories, sections: sections)
        return dominos
    }()
    
    lazy var dominosOdesa: RestaurantStruct = {
        let categories = "Pizza"
        let sections: [SectionStruct] = [sectionsBuilder.newSection, sectionsBuilder.popularSection, sectionsBuilder.pizzaSection]
        let dominos = createRestaurant(id: 8, version: 1, city: "Odesa", name: "Dominos",
                                       imageDataUrlString: "", price: 250, delivery: 0.5, rating: 5,
                                       categories: categories, sections: sections)
        return dominos
    }()
    
    func createRestaurant(id: Int, version: Int, city: String,
                                 name: String, imageDataUrlString: String,
                                 price: Int?, delivery: Float?,
                                 rating: Int?, categories: String?,
                                 sections: [SectionStruct] ) -> RestaurantStruct {
        let restaurantStruct = RestaurantStruct(id: id, version: version, city: city,
                                                name: name,
                                                image_data_url_string: imageDataUrlString,
                                                price: price, delivery: delivery,
                                                rating: rating, categories: categories,
                                                sections: sections)
        return restaurantStruct
    }
}
