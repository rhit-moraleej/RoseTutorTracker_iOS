//
//  FavoriteTableViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/18/22.
//

import UIKit
import Firebase

class FavoriteTableViewController: UITableViewController {
    let kFavsCell = "FavsCell"
    let kTutorDetailSegue = ""
    var logoutHandle: AuthStateDidChangeListenerHandle?
    var tutorListeningRegistration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForTutor()
        logoutHandle = AuthManager.shared.addLogoutObserver {
            print("Logging out!")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForTutor()
        AuthManager.shared.removeObserver(logoutHandle)
    }
    
    func startListeningForTutor(){
        stopListeningForTutor()

        tutorListeningRegistration = UserDocumentManager.shared.startListeningStudent(for: Auth.auth().currentUser!.uid) {
            UserDocumentManager.shared.getFavTutors(){
                self.tableView.reloadData()
//                print("Favorite tutors: \(UserDocumentManager.shared.favTutors)")
            }

//            self.tableView.reloadData()
        }
    }
    
    func stopListeningForTutor(){
        UserDocumentManager.shared.stopListening(tutorListeningRegistration)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDocumentManager.shared.favTutors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kFavsCell, for: indexPath) as! TutorViewCell
        
        let tutor = UserDocumentManager.shared.favTutors[indexPath.row]
        print("Tutor cell: \(tutor)")
        cell.tutorNameLabel.text = tutor.studentInfo!.name
        cell.tutorLocationLabel.text = "Location: \(tutor.location)"
        cell.tutorMajorLabel.text = "Major: \(tutor.studentInfo!.major)"
        let image = tutor.checkAvalability() ? UIImage(systemName: "checkmark")!.withTintColor(.green) : UIImage(systemName: "xmark")!.withTintColor(.red)
        cell.tutorAvailablity.image = image
        cell.tutorAvailablity.tintColor = tutor.checkAvalability() ? .green : .red
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            UserDocumentManager.shared.delete(index)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTutorDetail" {
            let details = segue.destination as! TutorDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let tutor = UserDocumentManager.shared.favTutors[indexPath.row]
                details.tutorDetail = tutor
            }
        }
        if segue.identifier == "findTutor" {
            //
        }
//        if segue.identifier == "homeToSetting" {
//            let details = segue.destination as! SettingViewController
//        }
    }
}
