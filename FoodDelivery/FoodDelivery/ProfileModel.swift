//
//  ProfileModel.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 18.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import RealmSwift

protocol ProfileModelProtocol {
    func createUserProfileIfNeeded()
}

class ProfileModel: NSObject {
    fileprivate func verifyUserProfileExists() -> Bool {
        let realm = try! Realm()
        let realmProfile = realm.objects(Profile.self)
        
        return realmProfile.first != nil
    }
    
    fileprivate func createUserProfile() {
        let realm = try! Realm()
        
        let profile = Profile()
        
        try! realm.write {
            realm.add(profile)
        }
    }
}

extension ProfileModel: ProfileModelProtocol {
    func createUserProfileIfNeeded() {
        guard verifyUserProfileExists() == true else {
            createUserProfile()
            return
        }
    }
}
