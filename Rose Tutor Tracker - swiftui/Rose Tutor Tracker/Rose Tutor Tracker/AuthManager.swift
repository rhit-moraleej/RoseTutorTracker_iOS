//
//  AuthManager.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/7/22.
//

import Foundation
import Rosefire
import Firebase

class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    var listenerHandler: AuthStateDidChangeListenerHandle!
    var isSignedIn: Bool { return currentUser != nil }
    
    private init(){
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
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
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out failed: \(error)")
        }
    }
    
    func fetchUser() {
            guard let uid = self.userSession?.uid else { return }
            
            fetchUser(withUid: uid) { user in
                self.currentUser = user
            }
        }
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
            Firestore.firestore().collection("users")
                .document(uid)
                .getDocument { snapshot, _ in
                    guard let snapshot = snapshot else { return }
                    
//                    guard let user = try? snapshot.data(as: User.self) else { return }
//                   completion(user)
                }
        }
}
