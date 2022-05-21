//
//  SettingViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/19/22.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
//    var tutorDetail: Tutor!
    
    @IBOutlet weak var userProPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var becomeTutorButton: UIButton!
    @IBOutlet weak var tutorSettings: UIStackView!
    var userListen: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorSettings.isHidden = true
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userListen = UserDocumentManager.shared.startListeningStudent(for: AuthManager.shared.currentUser!.uid){
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDocumentManager.shared.stopListening(userListen)
    }
    
    func updateView(){
        print(UserDocumentManager.shared.currTutor!)
        if let student = UserDocumentManager.shared.currStudent {
            if !UserDocumentManager.shared.currStudent!.storageUriString.isEmpty {
                ImageUtils.load(imageView: userProPic, from: UserDocumentManager.shared.currStudent!.storageUriString)
//                userProPic.makeRounded()
            }
            if student.tutor {
                becomeTutorButton.isHidden = true
                tutorSettings.isHidden = false
            }
            userName.text = "Name: \(student.name)"
            userEmail.text = "Email: \(student.email)"
        }
    }
    
    @IBAction func becomeTutor(_ sender: Any) {
        UserDocumentManager.shared.becomeTutor()
    }
    @IBAction func updateUserDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "userDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetail" {
//            let update = segue.destination as! UserUpdateViewController
//            update.userData = UserDocumentManager.shared.currStudent!
        }
    }
}
