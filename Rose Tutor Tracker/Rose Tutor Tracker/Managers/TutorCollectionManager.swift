//
//  TutorCollectionManager.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/18/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class TutorCollectionManager {
    
    var _studentCollectionRef: CollectionReference
    var _tutorCollectionRef: CollectionReference
    var _latestTutor: Tutor?
    var tutors = [Tutor]()
    
    static let shared = TutorCollectionManager()
    private init() {
        _studentCollectionRef = Firestore.firestore().collection("Students")
        _tutorCollectionRef = Firestore.firestore().collection("Tutors")
    }

    func startListening(changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        let query = _tutorCollectionRef
        
        return query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
//            self.tutors.removeAll()
//            self.tutors = documents.compactMap{ document in
//
//                do {
//                    let result = try document.data(as: Tutor.self)
//
//                    print(result)
//                    return result
//
//                } catch {
//                    print(error.localizedDescription)
//                }
//                return nil
//            }
            changeListener()
        }
    }
    
    func startListeningStudent(for documentID: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        let query = _tutorCollectionRef.document(documentID)
        return query.addSnapshotListener { snap, error in
            guard let document = snap else {
                print("Error fetching document: \(error!)")
                return
            }
            guard document.data() != nil else {
                print("Document data is empty")
                return
            }
            
            do{
                let tutor = try snap?.data(as: Tutor.self)
                self.getStudent(documentID, tutor!, changeListener)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getStudent(_ id: String, _ tutor: Tutor, _ changeListener: @escaping (() -> Void)){
        self._studentCollectionRef.document(id).getDocument { snap, err in
            do{
                let student = try snap?.data(as: Student.self)
                var tutor = tutor
                tutor.studentInfo = student
                self._latestTutor = tutor
            } catch {
                print(error.localizedDescription)
            }
            changeListener()
        }
    }
    
    func getStudent( _ tutor: Tutor, _ changeListener: @escaping (() -> Void)){
        self._studentCollectionRef.document(tutor.id!).getDocument { snap, err in
            do{
                let student = try snap?.data(as: Student.self)
                var tutor = tutor
                tutor.studentInfo = student
                print("Adding \(tutor)")
                self.tutors.append(tutor)
            } catch {
                print(error.localizedDescription)
            }
            changeListener()
        }
    }
    
    func getTutor(_ student: Student, _ changeListener: @escaping (() -> Void)) {
        self._tutorCollectionRef.document(student.uid!).getDocument  { snap, err in
            do {
                var tutor = try snap!.data(as: Tutor.self)
                tutor.studentInfo = student
                print("Adding \(tutor)")
                self.tutors.append(tutor)
            } catch {
                print(error.localizedDescription)
            }
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    /**
     Search types:
     - 0: search by name
     - 1: search by course
     */
    func searchBy(filterBy searchType: Int, searchTerm: String = "", changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        print("Searching")
        if searchType == 0 {
            print("Searching by name")
            let newSearchTerm = searchTerm.titlecased()
            print("new searchTerm: \(newSearchTerm)")
            let query = _studentCollectionRef
                .whereField("name", isGreaterThanOrEqualTo: newSearchTerm)
                .whereField("name", isLessThanOrEqualTo: newSearchTerm + "z")
                .whereField("tutor", isEqualTo: true)
            return query.addSnapshotListener { snap, err in
                guard let documents = snap?.documents else {
                    print("Error fetching documents: \(err!)")
                    return
                }
                self.tutors.removeAll()
                print(documents)
                for document in documents {
                    do {
                        let student = try document.data(as: Student.self)
                        print("searched studetn data")
                        if student.uid != AuthManager.shared.currentUser?.uid {
                            self.getTutor(student, changeListener)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                changeListener()
            }
        } else {
            print("Searching by course")
            let newSearchTerm = searchTerm.uppercased()
            print(newSearchTerm)
            let query = _tutorCollectionRef.whereField("courses", arrayContains: newSearchTerm)
            
            return query.addSnapshotListener { snap, err in
                guard let documents = snap?.documents else {
                    print("Error fetching documents: \(err!)")
                    return
                }
                self.tutors.removeAll()
                print(documents)
                for document in documents {
                    do {
                        let tutor = try document.data(as: Tutor.self)
                        if tutor.id != AuthManager.shared.currentUser?.uid {
                            self.getStudent(tutor, changeListener)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                changeListener()
            }
        }
    }
}
