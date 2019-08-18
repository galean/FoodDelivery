//
//  AppDelegate.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit
import Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupUserProfile()
        return true
    }
    
    func setupUserProfile() {
        let profile: ProfileModelProtocol = ProfileModel()
        profile.createUserProfileIfNeeded()
    }
}

