//
//  LoginViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/17/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
//    var rosefireName: String?
    var loginHandle: AuthStateDidChangeListenerHandle?
    var rosefireResult: RosefireResult!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginHandle = AuthManager.shared.addLoginObserver {
            print("Login complete.")
            // TODO: preform segue to home page
            self.performSegue(withIdentifier: "toHomePage", sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(loginHandle)
    }
    
    
    @IBAction func rosefireLogin(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self
        Rosefire.sharedDelegate().signIn(registryToken: privateKey) { (err, result) in
            if let err = err {
                print("Rosefire sin in error: \(err.localizedDescription)")
            }
            print("Rosefire worked. Name = \(result!.name!)")
//            self.rosefireName = result!.name
            self.rosefireResult = result!
            
            AuthManager.shared.signInWithRosefireToken(result!.token)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toHomePage" {
            UserDocumentManager.shared.addNewUserMaybe(AuthManager.shared.currentUser!.uid)
        }
    }
}
