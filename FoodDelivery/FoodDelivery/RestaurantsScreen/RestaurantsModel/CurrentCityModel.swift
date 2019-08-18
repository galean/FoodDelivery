//
//  DefaultCityModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 18.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit
import RealmSwift

protocol CurrentCityModelProtocol {
    var delegate: CurrentCityModelDelegate? { get set }
    var currentCity: City? { get }
    var currentCityName: String? { get }
    func fetchCurrentCity()
}

protocol CurrentCityModelDelegate: NSObject {
    func fetchedCurrentCity()
}

class CurrentCityModel: NSObject {
    weak var delegate: CurrentCityModelDelegate?
    
    lazy var serverModel: DefaultCityServerModelProtocol = {
        let serverModel = DefaultCityServerModel()
        serverModel.delegate = self
        return serverModel
    }()
    
    var currentCity: City? {
        didSet {
            if currentCity != nil {
                delegate?.fetchedCurrentCity()
            }
        }
    }
    
    func getCurrentCity() -> City? {
        let realm = try! Realm()
        let profile = realm.objects(Profile.self).first!
        return profile.currentCity
    }
    
    //MARK:- Internal
    fileprivate func verifyCurrentCityExists() -> Bool {
        let currentCity = getCurrentCity()
        return currentCity != nil
    }
    
    func updateCity(with cityData: CityStruct) {
        let realm = try! Realm()
        
        let profile = realm.objects(Profile.self).first!
        
        let city = City.fromCityStruct(cityData)
        
        try! realm.write {
            profile.currentCity = city
        }
        
        DispatchQueue.main.async {
            self.currentCity = self.getCurrentCity()
        }
    }
}

extension CurrentCityModel: CurrentCityModelProtocol {
    func fetchCurrentCity() {
        DispatchQueue.main.async {
            guard self.verifyCurrentCityExists() == true else {
                DispatchQueue.global().async {
                    self.serverModel.requestDefaultCity()
                }
                return
            }
            self.currentCity = self.getCurrentCity()
            self.delegate?.fetchedCurrentCity()
        }
    }
    
    var currentCityName: String? {
        return currentCity?.name
    }
}

extension CurrentCityModel: DefaultCityServerModelDelegate {
    func defaultCityResponse(_ responseData: CityRespData?, error: NSError?) {
        guard error == nil else {
            //TODO: Handle it!!!!
            assert(false)
            return
        }
        
        guard let cityData = responseData else {
            //TODO: TODO: Server error
            assert(false)
            return
        }
        
        updateCity(with: cityData.city)
    }
}
