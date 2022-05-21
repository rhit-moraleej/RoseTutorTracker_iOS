//
//  SettingsSideNav.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/20/22.
//

import UIKit
import Firebase

class SettingsSideNav: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userProPic: UIImageView!
    
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
    
    
    @IBAction func homeButton(_ sender: Any) {
    }
    
    
    
}
