//
//  TutorDetailViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/18/22.
//

import UIKit
import Firebase

class TutorDetailViewController: UIViewController {
    var tutorDetail: Tutor!
    
    @IBOutlet weak var tutorProfileImage: UIImageView!
    @IBOutlet weak var tutorNameLabel: UILabel!
    @IBOutlet weak var tutorEmailLabel: UILabel!
    @IBOutlet weak var tutorClassLabel: UILabel!
    @IBOutlet weak var tutorCourseLabel: UILabel!
    @IBOutlet weak var tutorLocationLabel: UILabel!
    @IBOutlet weak var tutorAvailability: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var userListener: ListenerRegistration?
    var tutorListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tutorListener = TutorCollectionManager.shared.startListening {
            self.updateView()
            self.userListener = UserDocumentManager.shared.startListeningStudent(for: Auth.auth().currentUser!.uid){
                //
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TutorCollectionManager.shared.stopListening(tutorListener)
        UserDocumentManager.shared.stopListening(userListener)
    }
    
    func updateView() {
        if let tutor = tutorDetail {
            if !tutorDetail.studentInfo!.storageUriString.isEmpty {
                ImageUtils.load(imageView: tutorProfileImage, from: tutorDetail.studentInfo!.storageUriString)
            }
            tutorNameLabel.text = "Name: \(tutor.studentInfo!.name)"
            tutorEmailLabel.text = "Email: \(tutor.studentInfo!.email)"
            tutorClassLabel.text = "Class of \(tutor.studentInfo!.classYear)"
            // TODO: make courses to string func
            tutorCourseLabel.text = tutorDetail.coursesToString()
            tutorLocationLabel.text = "Location:  \(tutor.location)"
            tutorAvailability.text = tutorDetail.daysToString()
            favButton.setTitle(UserDocumentManager.shared.contains(tutorDetail!.id!) ? "UNFAVORITE" : "FAVORITE", for: .normal)
        }
    }
    
    
    @IBAction func pressedFavButton(_ sender: Any) {
        if UserDocumentManager.shared.contains(tutorDetail!.id!) {
            let index = UserDocumentManager.shared.currStudent?.favoriteTutors.firstIndex(of: tutorDetail!.id!)
            UserDocumentManager.shared.currStudent?.favoriteTutors.remove(at: index!)
            UserDocumentManager.shared.updateStudent()
            updateView()
            self.navigationController!.popViewController(animated: true)
        } else {
            UserDocumentManager.shared.currStudent?.favoriteTutors.append(tutorDetail!.id!)
            UserDocumentManager.shared.updateStudent()
            updateView()
        }
    }
}

