//
//  CoursesTableViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/20/22.
//

import UIKit
import Firebase

class courseCell: UITableViewCell {
    
    @IBOutlet weak var courseName: UILabel!
}

class CoursesTableViewController: UITableViewController {
    let kCourseCel = "CourseCell"
    var tutorListeningRegistration: ListenerRegistration?
    
    @IBOutlet weak var locationTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addCourse))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForCourses()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForCourses()
    }
    
    func startListeningForCourses() {
        stopListeningForCourses()  // This will do nothing the first time, but be useful later.
        tutorListeningRegistration = UserDocumentManager.shared.startListeningTutor(for: UserDocumentManager.shared.currTutor!.id!){
            self.locationTextFeild.text = UserDocumentManager.shared.currTutor?.location
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForCourses() {
        UserDocumentManager.shared.stopListening(tutorListeningRegistration)
    }
    
    @IBAction func locationchanged(_ sender: Any) {
        UserDocumentManager.shared.currTutor?.location = locationTextFeild.text!
        UserDocumentManager.shared.updateTutor()
    }
    @objc func addCourse() {
        let alertController = UIAlertController(title: "Add course",
                                                message: "Please enter the course code (ie. CSSE484 or SX 169)",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Course"
        }

        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("You pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        // Positive button
        let createQuoteAction = UIAlertAction(title: "Create Course", style: UIAlertAction.Style.default) { action in
            print("You pressed create course")
            
            let courseTextField = alertController.textFields![0] as UITextField

            print("Quote: \(courseTextField.text!)")
            
            UserDocumentManager.shared.currTutor?.courses.append(courseTextField.text!)
            UserDocumentManager.shared.updateTutor()
        }
        alertController.addAction(createQuoteAction)
        
        
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDocumentManager.shared.currTutor!.courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCourseCel, for: indexPath) as! courseCell
        
        let course = UserDocumentManager.shared.currTutor?.courses[indexPath.row]
        cell.courseName.text = course
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            UserDocumentManager.shared.currTutor?.courses.remove(at: index)
            UserDocumentManager.shared.updateTutor()
        }
    }
}
