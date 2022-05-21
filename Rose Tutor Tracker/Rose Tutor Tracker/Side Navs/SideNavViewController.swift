//
//  SideNavViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/18/22.
//

import UIKit

class SideNavViewController: UIViewController {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var tableViewController: FavoriteTableViewController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! FavoriteTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.makeRounded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UserDocumentManager.shared.currStudent!.storageUriString.isEmpty {
            ImageUtils.load(imageView: self.userProfileImage, from: UserDocumentManager.shared.currStudent!.storageUriString)
//                userPropic.makeRounded()
        }
        userName.text = UserDocumentManager.shared.currStudent?.name
        userEmail.text = UserDocumentManager.shared.currStudent?.email
    }
    
    @IBAction func pressedFindTutor(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: "findTutor",
                                         sender: tableViewController)
    }
    
    @IBAction func pressedHome(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressedSetting(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: "homeToSetting",
                                         sender: tableViewController)

    }
    
    @IBAction func signOut(_ sender: Any) {
        dismiss(animated: true){
            AuthManager.shared.signOut()
        }
    }
}
