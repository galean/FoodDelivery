//
//  RestaurantsModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit
import RealmSwift

protocol RestaurantsModelProtocol {
    var delegate: RestaurantsModelDelegate? { get set }
    func fetchRestaurants()
    
    var sectionNames: [String] { get }
    var restaurantsForSection: [[RestaurantStruct]] { get }
}

protocol RestaurantsModelDelegate: NSObject {
    var currentCity: City? { get }
    func fetchedRestaurants()
}

class RestaurantsModel: NSObject {
    weak var delegate: RestaurantsModelDelegate?
    
    lazy var serverModel: RestaurantsServerModelProtocol = {
        let serverModel = RestaurantsServerModel()
        serverModel.delegate = self
        return serverModel
    }()
    
    var currentCity: City? {
        return delegate?.currentCity
    }
    
    //MARK:- Internal
    fileprivate func updateRestaurants(with cityRestResponse: RestaurantsRespData) {
        let cityStruct = cityRestResponse.city
        let restaurantsStructs = cityRestResponse.restaurants
        
        var restaurantsArr = [Restaurant]()
        for restStruct in restaurantsStructs {
            let restaurant = Restaurant.fromRestaurantStruct(restStruct)
            restaurantsArr.append(restaurant)
        }
        
        let realm = try! Realm()
        let profile = realm.objects(Profile.self).first!
        let modifiedCity = City()
        modifiedCity.id = cityRestResponse.city.id
        modifiedCity.name = cityRestResponse.city.name
        modifiedCity.version = cityRestResponse.city.version
        modifiedCity.restaurants.append(objectsIn: restaurantsArr)
        
        realm.beginWrite()
            realm.add(modifiedCity, update: .modified)
        try! realm.commitWrite()

        realm.beginWrite()
        profile.currentCity = modifiedCity
        try! realm.commitWrite()

        
        DispatchQueue.main.async {
            self.delegate?.fetchedRestaurants()
        }
    }
}

extension RestaurantsModel: RestaurantsModelProtocol {
    func fetchRestaurants() {
        DispatchQueue.global().async {
            let realm = try! Realm()
            let city = realm.objects(Profile.self).first!.currentCity
            guard let id = city?.id, let version = city?.version else {
                assert(false)
                //TODO: TODO: Handle it as an internal error
                return
            }
            if city == nil || city?.restaurants.count == 0 {
                self.serverModel.requestRestaurants(forCity: id, version: nil)
            } else {
                self.serverModel.requestRestaurants(forCity: id, version: version)
            }
        }
    }
    
    var sectionNames: [String] {
        guard currentCity?.restaurants != nil else {
            return []
        }
        
        let realm = try! Realm()
        let sections = realm.objects(Section.self).sorted { $0.id < $1.id }
        var sectionStrings = [String]()
        for section in sections {
            sectionStrings.append(section.name)
        }
        return sectionStrings
    }
    
    var restaurantsForSection: [[RestaurantStruct]] {
        guard currentCity?.restaurants != nil else {
            return [[]]
        }
        
        let realm = try! Realm()
        let city = realm.objects(Profile.self).first!.currentCity!
        
        let sections = realm.objects(Section.self).sorted { $0.id < $1.id }
        var restaurantsForSections = [[RestaurantStruct]]()
        for section in sections {
            let predicate = "ANY sections.name = %@"
            let restaurants = section.ofRestaurants.filter(predicate, section.name)
            let cityPredicate = "ANY ofCity.name = %@"
            let cityRestaurants = restaurants.filter(cityPredicate, city.name)
            //let rmProducts = realm.objects(Product.self).filter("SUBQUERY(productTypeList, $type, $type.typeName == %@).@count>0",productTypeName)
            var restStructs = [RestaurantStruct]()
            for rest in cityRestaurants {
                restStructs.append(rest.toStruct())
            }
            restaurantsForSections.append(restStructs)
        }
        return restaurantsForSections
    }
}

extension RestaurantsModel: RestaurantsServerModelDelegate {
    func restaurantsResponse(_ responseData: RestaurantsRespData?, error: NSError?) {
        guard error == nil else {
            //TODO: Handle it!!!!
            assert(false)
            delegate?.fetchedRestaurants()
            return
        }
        
        guard let restaurantsData = responseData else {
            //Nothing changed on the server
            self.delegate?.fetchedRestaurants()
            return
        }
        
        updateRestaurants(with: restaurantsData)
    }
}





//protocol RestaurantsModelProtocol {
//    func fetchCurrentCity()
//    func fetchRestaurants(city: String)
//}
//
//protocol RestaurantsModelDelegate: NSObject {
//    func fetchedRestaurants()
//}
//
//class RestaurantsModel: NSObject {
//    lazy var restaurants: CityRestaurants? = {
//        let realm = try! Realm()
//        let allRestaurants = realm.objects(CityRestaurants.self)
//        let restaurants = allRestaurants.first
//        return restaurants
//    }()
//
//    lazy var serverModel: RestaurantsModelServerProtocol = {
//        let server = RestaurantsModelServerMock()
//        server.delegate = self
//        return server
//    }()
//
//    weak var delegate: RestaurantsModelDelegate?
//
//    func internalFetch(city: String) {
//        let version = restaurants?.version ?? 0
//        serverModel.requestRestaurants(forCity: city, currentVersion: version)
//    }
//
//    func updateRestaurants(with restaurantsData: RestaurantsResponseData) {
//        let realm = try! Realm()
//
//        let restaurants = CityRestaurants.fromResponseData(restaurantsData)
//
//        try! realm.write {
//            self.restaurants = restaurants
//        }
//    }
//}
//
//extension RestaurantsModel: RestaurantsModelProtocol {
//    var restaurantsForSections: [RestaurantSection: [Restaurant]] {
//        var restaurantsForSections = [RestaurantSection: [Restaurant]]()
//
//        guard let cityRestaurants = restaurants else {
//            return restaurantsForSections
//        }
//
//        for section in sections {
//            let restaurants: [Restaurant]
//            restaurants = cityRestaurants.restaurants.compactMap{
//                (restaurant) -> Restaurant? in
//                let result = restaurant.sections.contains(section) ? restaurant : nil
//                return result
//            }
//            restaurantsForSections[section] = restaurants
//        }
//
//        return restaurantsForSections
//    }
//
//    var sections: [RestaurantSection] {
//        guard let cityRestaurants = restaurants else {
//            return []
//        }
//
//        return Array(cityRestaurants.sections)
//    }
//
//    func fetchRestaurants(city: String) {
//        internalFetch(city: city)
//    }
//}
//
//extension RestaurantsModel: RestaurantsModelServerDelegate {
//    func restaurantsResponse(data: RestaurantsResponseData?,
//                             error: NSError?) {
//        defer {
//            self.delegate?.fetchedRestaurants()
//        }
//
//        guard error == nil else {
//            //TODO: Handle it!!!!
//            assert(false)
//            return
//        }
//
//        guard let restaurantsData = data else {
//            //TODO: Handle it!!!!
//            assert(false)
//            return
//        }
//
//        updateRestaurants(with: restaurantsData)
//    }
//}
