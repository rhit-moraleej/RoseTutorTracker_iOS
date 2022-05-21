//
//  UserData.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/17/22.
//

import Foundation


struct UserData {
    static let userName = "userName"
//    static let name = "name"
//    static let email = "email"
    static let loggedIn = "loggedIn"
    
    static func getLoggedIn() -> Bool {
        print(UserDefaults.standard.bool(forKey: UserData.loggedIn))
        return UserDefaults.standard.bool(forKey: UserData.loggedIn)
    }
    
    
}
