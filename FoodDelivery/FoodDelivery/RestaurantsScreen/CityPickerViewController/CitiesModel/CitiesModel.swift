////
////  CitiesModel.swift
////  FoodDelivery
////
////  Created by Galean Pallerman on 17.08.2019.
////  Copyright © 2019 GPco. All rights reserved.
////

import Foundation
import RealmSwift

protocol CitiesModelProtocol: NSObject {
    var delegate: CitiesModelDelegate? { get set }
    var cities: [CityStruct] { get }
    var currentCityName: String? { get set }
    func fetchCities()
    
    func chosenCity(atIndex index: Int)
}

protocol CitiesModelDelegate: NSObject {
    func fetchedCities()
    func profileUpdated()
}

class CitiesModel: NSObject {
    weak var delegate: CitiesModelDelegate?
    
    lazy var serverModel: CitiesServerModelProtocol = {
        let serverModel = CitiesServerModel()
        serverModel.delegate = self
        return serverModel
    }()
    
    var cities: [CityStruct] = [] {
        didSet {
            delegate?.fetchedCities()
        }
    }
    
    var currentCityName: String?
    
    //MARK:- Internal
    func updateCities(with citiesStructs: [CityStruct]) {
       self.cities = citiesStructs
    }
}

extension CitiesModel: CitiesModelProtocol {
    func chosenCity(atIndex index: Int) {
        defer {
            delegate?.profileUpdated()
        }
        let realm = try! Realm()
        let profile = realm.objects(Profile.self).first!
        
        guard let currCity = profile.currentCity else {
            //Should not be possible, internal error
            assert(false)
            return
        }
        let newCityStruct = cities[index]
        guard currCity.id != newCityStruct.id else {
            return
        }
        
        let realmNewCity = realm.object(ofType: City.self, forPrimaryKey: newCityStruct.id)
        guard realmNewCity?.version != newCityStruct.version else {
            try! realm.write {
                profile.currentCity = realmNewCity
            }
            return
        }
        
        let newCity = City.fromCityStruct(newCityStruct)
        try! realm.write {
            profile.currentCity = newCity
        }
    }
    
    func fetchCities() {
        DispatchQueue.global().async {
            self.serverModel.requestCities()
        }
    }
}

extension CitiesModel: CitiesServerModelDelegate {
    func citiesResponse(_ responseData: CitiesRespData?, error: NSError?) {
        guard error == nil else {
            //TODO: TODO: Handle it!!!!
            assert(false)
            return
        }
        
        guard let citiesData = responseData else {
            //TODO: TODO: Server error
            assert(false)
            return
        }
        
        updateCities(with: citiesData.cities)
    }
}


