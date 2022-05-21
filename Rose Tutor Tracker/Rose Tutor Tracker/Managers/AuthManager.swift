//
//  AuthManager.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/7/22.
//

import Foundation
import Firebase

class AuthManager: ObservableObject {
    static let shared = AuthManager()

    var listenerHandler: AuthStateDidChangeListenerHandle!
    var isSignedIn: Bool { return currentUser != nil }
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    private init(){}
    
    func addLoginObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { auth, user in
            if (user != nil) {
                callback()
            }
        }
    }
    
    func addLogoutObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { auth, user in
            if (user == nil) {
                callback()
            }
        }
    }
    
    func removeObserver(_ authDidChangeHandle: AuthStateDidChangeListenerHandle?) {
        if let authHandle = authDidChangeHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func signInWithRosefireToken(_ rosefireToken: String) {
        Auth.auth().signIn(withCustomToken: rosefireToken) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error! \(error)")
                return
            }
            // User is signed in using Firebase!
            print("The user is now actually signed in using the Rosefire token")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out failed: \(error)")
        }
    }
}
