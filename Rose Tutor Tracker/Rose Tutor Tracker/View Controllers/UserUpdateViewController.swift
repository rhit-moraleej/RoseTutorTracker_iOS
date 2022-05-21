//
//  UserUpdateViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/19/22.
//

import UIKit
import Firebase

class UserUpdateViewController: UIViewController {
//    var userData: Student!
    
    @IBOutlet weak var userPropic: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var classYear: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    var userListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userListener = UserDocumentManager.shared.startListeningStudent(for: UserDocumentManager.shared.currStudent!.uid!){
            self.updateView()
        }
    }
    
    func updateView(){
        if let student = UserDocumentManager.shared.currStudent {
            if !student.storageUriString.isEmpty {
                ImageUtils.load(imageView: userPropic, from: student.storageUriString)
//                userPropic.makeRounded()
            }
            
            userName.text = student.name
            userEmail.text = student.email
            classYear.text = String(student.classYear)
            major.text = student.major
        }
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func updateButton(_ sender: Any) {
        UserDocumentManager.shared.currStudent!.classYear = Int(classYear.text!)!
        UserDocumentManager.shared.currStudent!.major = major.text!
//        UserDocumentManager.shared.currStudent = userData
        UserDocumentManager.shared.updateStudent()
        updateView()
    }
}

extension UserUpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            StorageManager.shared.uploadProfilePhoto(uid: UserDocumentManager.shared.currStudent!.uid!, image: image){
                self.updateView()
            }
            
        }
        picker.dismiss(animated: true)
    }
}
