//
//  DefaultCityServerModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 18.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

protocol DefaultCityServerModelProtocol {
    var delegate: DefaultCityServerModelDelegate? { get set }
    func requestDefaultCity()
}

protocol DefaultCityServerModelDelegate {
    func defaultCityResponse(_ responseData: CityRespData?, error: NSError?)
}

class DefaultCityServerModel: NSObject {
    var delegate: DefaultCityServerModelDelegate?
    #if DEBUG
    let serverModel: ServerModelProtocol = ServerModelMock()
    #else
    let serverModel: ServerModelProtocol = ServerModel()
    #endif
}

extension DefaultCityServerModel: DefaultCityServerModelProtocol {
    func requestDefaultCity() {
        serverModel.requestDefaultCity { (responseData, error) in
            self.delegate?.defaultCityResponse(responseData, error: error)
        }
    }
}
