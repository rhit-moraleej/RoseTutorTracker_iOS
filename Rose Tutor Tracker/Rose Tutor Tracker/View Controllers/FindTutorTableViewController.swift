//
//  FindTutorTableViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/19/22.
//

import UIKit
import Firebase

class FindTutorTableViewController: UITableViewController, UISearchBarDelegate {
    let kTutorCell = "TutorCell"
    var tutorListener: ListenerRegistration?
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    var searchType = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.title = "Find a Tutor"
        searchBar.placeholder = (searchType == 0) ? "Search by Name" : "Search by Course"
        searchBar.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search By",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showMenu))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForTutors()
    }
    
    func startListeningForTutors(){
        stopListeningForTutors()
        tutorListener = TutorCollectionManager.shared.startListening {
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForTutors(){
        TutorCollectionManager.shared.stopListening(tutorListener)
    }
    
    @objc func showMenu() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: UIAlertController.Style.actionSheet)
        
        let searchByName = UIAlertAction(title: "Search by Name", style: UIAlertAction.Style.default) { action in
            self.searchType = 0
            self.updateView()
        }
        alertController.addAction(searchByName)

        let searchByCourse = UIAlertAction(title: "Search by Course", style: UIAlertAction.Style.default) { action in
            self.searchType = 1
            self.updateView()
        }
        alertController.addAction(searchByCourse)

        present(alertController, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TutorCollectionManager.shared.tutors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTutorCell, for: indexPath) as! TutorViewCell
        let tutor = TutorCollectionManager.shared.tutors[indexPath.row]
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
        return false
    }
    
    func updateView(){
        searchBar.placeholder = (searchType == 0) ? "Search by Name" : "Search by Course"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text!
        tutorListener = TutorCollectionManager.shared.searchBy(filterBy: searchType, searchTerm: searchTerm, changeListener: self.tableView.reloadData)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFindToDetail" {
            let details = segue.destination as! TutorDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let tutor = TutorCollectionManager.shared.tutors[indexPath.row]
                details.tutorDetail = tutor
            }
        }
    }
}
