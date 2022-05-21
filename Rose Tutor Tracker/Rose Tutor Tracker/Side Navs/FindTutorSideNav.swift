//
//  FindTutorSideNav.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/19/22.
//

import UIKit
import Firebase

class FindTutorSideNav: UIViewController {
    
    @IBOutlet weak var userProPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var userListener: ListenerRegistration?
    
    var tableViewController: FindTutorTableViewController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! FindTutorTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProPic.makeRounded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userListener = UserDocumentManager.shared.startListeningStudent(for: UserDocumentManager.shared.currStudent!.uid!){
            if !UserDocumentManager.shared.currStudent!.storageUriString.isEmpty {
                ImageUtils.load(imageView: self.userProPic, from: UserDocumentManager.shared.currStudent!.storageUriString)
    //                userPropic.makeRounded()
            }
            self.userName.text = UserDocumentManager.shared.currStudent?.name
            self.userEmail.text = UserDocumentManager.shared.currStudent?.email
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDocumentManager.shared.stopListening(userListener)
    }
    
    @IBAction func pressedHome(_ sender: Any) {
        dismiss(animated: true)
        self.tableViewController.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func pressedFind(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressedSetting(_ sender: Any) {
    }
    
    @IBAction func signOut(_ sender: Any) {
        dismiss(animated: true){
            AuthManager.shared.signOut()
        }
    }
}
