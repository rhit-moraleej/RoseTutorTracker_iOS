//
//  LoginViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/7/22.
//

import Foundation
import UIKit
import Rosefire
import Firebase

class LoginViewController: UIViewController{
    let REGISTRY_TOKEN = "f7f24e15-a26d-4080-97c4-86343be095d1"

    func loginWithRosefire(){
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
            if let err = err {
                print("Rosefire sign in error! \(err)")
                return
            }
            print("Result = \(result!.token!)")
            print("Result = \(result!.username!)")
            print("Result = \(result!.name!)")
            print("Result = \(result!.email!)")
            print("Result = \(result!.group!)")
            Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
                if let error = error {
                    print("Firebase sign in error! \(error)")
                    return
                }
                // User is signed in using Firebase!
            }
        }
    }

}
