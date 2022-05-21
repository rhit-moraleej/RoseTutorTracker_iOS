//
//  UserDocumentManager.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/17/22.
//

import Foundation
import Firebase

class UserDocumentManager {
    var currStudent: Student?
    var currTutor: Tutor?
    var studentCollectionRef: CollectionReference
    var tutorCollectionRef: CollectionReference
    
    var favTutors = [Tutor]()
    
    static let shared = UserDocumentManager()
    private init(){
        studentCollectionRef = Firestore.firestore().collection("Students")
        tutorCollectionRef = Firestore.firestore().collection("Tutors")
    }
    
    func addNewUserMaybe(_ uid: String){
        let docRef = studentCollectionRef.document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                print("Student data found!")
                //                print(document.data())
                do{
                    let result = try document.data(as: Student.self)
                    self.currStudent = result
                    if self.currStudent!.tutor {
//                        self.getFavTutors {
//                            self.getUserTutorInfo()
//                        }
                    }
                    print(self.currStudent!)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Data not found, creating new user")
                let newStudent = Student(name: "",
                                         email: "",
                                         major: "",
                                         classYear: 0,
                                         favoriteTutors: [],
                                         tutor: false,
                                         hasCompletedSetup: false,
                                         storageUriString: "")
                do{
                    _ = try docRef.setData(from: newStudent)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func startListeningStudent(for documentID: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        let query = studentCollectionRef.document(documentID)
        
        return query.addSnapshotListener { documentSnapshot, error in
            self.currStudent = nil
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard document.data() != nil else {
                print("Document data is empty")
                return
            }
            do{
                self.currStudent = try document.data(as: Student.self)
                if self.currStudent!.tutor {
                    self.getUserTutorInfo()
                }
                
            } catch {
                print(error.localizedDescription)
            }
            changeListener()
        }
    }
    
    func startListeningTutor(for documentID: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        let query = tutorCollectionRef.document(documentID)
        
        return query.addSnapshotListener { documentSnapshot, error in
            self.currTutor = nil
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard document.data() != nil else {
                print("Document data is empty")
                return
            }
            do{
                self.currTutor = try document.data(as: Tutor.self)
            } catch {
                print(error.localizedDescription)
            }
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    
    func getFavTutors(changeListener: @escaping (() -> Void)){
        self.favTutors.removeAll()
        for id in currStudent!.favoriteTutors {
            print("getting data for: \(id)")
            tutorCollectionRef.document(id).getDocument { documentSnapshot, error in
                do {
                    let tutor = try documentSnapshot?.data(as: Tutor.self)
                    self.getStudent(id, tutor!, changeListener)
                } catch {
                    print(error.localizedDescription)
                }
            }

        }
        print("Got all Favs")
        changeListener()
    }
    
    func getStudent(_ id: String, _ tutor: Tutor, _ changeListener: @escaping (() -> Void)){
        self.studentCollectionRef.document(id).getDocument { snap, err in
            do{
                let student = try snap?.data(as: Student.self)
                var tutor = tutor
                tutor.studentInfo = student
                self.favTutors.append(tutor)
            } catch {
                print(error.localizedDescription)
            }
            changeListener()
        }
    }
    
    func becomeTutor(){
        let newTutor = Tutor(id: currStudent?.uid, available: false, courses: [], location: "", hasCompletedSetup: false, days: [], studentInfo: currStudent!)
        currTutor = newTutor
        do {
            _ = try tutorCollectionRef.addDocument(from: currTutor)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getUserTutorInfo() {
        self.tutorCollectionRef.document(AuthManager.shared.currentUser!.uid).getDocument  { snap, err in
            do {
                self.currTutor = try snap!.data(as: Tutor.self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(_ index: Int) {
        currStudent?.favoriteTutors.remove(at: index)
        updateStudent()
    }
    
    func contains(_ id: String) -> Bool {
        return self.currStudent!.favoriteTutors.contains(id)
    }
    
    func updateStudent() {
        do {
            _ = try studentCollectionRef.document(AuthManager.shared.currentUser!.uid).setData(from: self.currStudent)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateTutor(){
        do{
            _ = try tutorCollectionRef.document(currTutor!.id!).setData(from: self.currTutor)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateDay(_ index: Int){
        currTutor?.days[index].working.toggle()
    }
    
    func updateDays(){
        
    }
}
