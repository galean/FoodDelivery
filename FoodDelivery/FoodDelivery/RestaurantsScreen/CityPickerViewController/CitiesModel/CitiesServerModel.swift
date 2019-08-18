////
////  CitiesModelServerMock.swift
////  FoodDelivery
////
////  Created by Galean Pallerman on 17.08.2019.
////  Copyright © 2019 GPco. All rights reserved.
////
//
//import Foundation
//
//protocol CitiesModelServerMockProtocol: NSObject {
//    func requestCities()
//}
//
//protocol CitiesModelServerMockDelegate: NSObject {
//    func citiesResponse(data: CitiesResponseData?, error: NSError?)
//}
//
//class CitiesModelServerMock: NSObject {
//    weak var delegate: CitiesModelServerMockDelegate?
//    
//    fileprivate func internalRequestCities() {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//            self.internalCitiesResponse()
//        }
//    }
//    
//    @objc fileprivate func internalCitiesResponse() {
//        let cities = ["Kyiv", "Odesa"]
//        let response = CitiesResponseData(cities: cities)
//        
//        self.delegate?.citiesResponse(data: response, error: nil)
//    }
//}
//
//extension CitiesModelServerMock: CitiesModelServerMockProtocol {
//    func requestCities() {
//        internalRequestCities()
//    }
//}


import Foundation

protocol CitiesServerModelProtocol {
    var delegate: CitiesServerModelDelegate? { get set }
    func requestCities()
}

protocol CitiesServerModelDelegate {
    func citiesResponse(_ responseData: CitiesRespData?, error: NSError?)
}

class CitiesServerModel: NSObject {
    var delegate: CitiesServerModelDelegate?
    #if DEBUG
    let serverModel: ServerModelProtocol = ServerModelMock()
    #else
    let serverModel: ServerModelProtocol = ServerModel()
    #endif
}

extension CitiesServerModel: CitiesServerModelProtocol {
    func requestCities() {
        serverModel.requestCities { (responseData, error) in
            self.delegate?.citiesResponse(responseData, error: error)
        }
    }
}

