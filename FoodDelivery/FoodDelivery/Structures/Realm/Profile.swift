//
//  Profile.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 18.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var currentCity: City?
    
    static override func primaryKey() -> String {
        return "id"
    }
}
