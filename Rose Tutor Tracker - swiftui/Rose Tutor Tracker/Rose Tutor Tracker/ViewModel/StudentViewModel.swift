//
//  StudentViewModel.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/9/22.
//

import SwiftUI

struct student: Codable {
    let name: String
    let classYear: Int
    let email: String
    let major: String
    let tutor: Bool
    let favoriteTutors: [String]
}

class StudentViewModel: ObservableObject{
    static let shared = StudentViewModel()
    @Published var student: Student? = Student(
        name: "Elvis Morales Campoverde", email: "moraleej@rose-hulman.edu", major: "CS", classYear: 2022,
        favoriteTutors: ["robert", "bob"], isTutor: true, hasCompletedSetup: true, uid: "moraleej")
    @Published var favTutors = [Tutor]()
    private init(){
        getFavs()
    }
    
    func addTutor(tutor: Tutor){
        // will need to send data back to firebase when changed
        student?.favoriteTutors.append(tutor.uid)
        favTutors.append(tutor)
    }
    
    func removeTutor(id: String){
        print("number of favs: \(favTutors.count)")
        print("Removing: \(id)")
        var index = student?.favoriteTutors.firstIndex(of: id)
        student?.favoriteTutors.remove(at: index!)
        for i in 0..<favTutors.count{
            if(favTutors[i].uid == id){
                print("removed tutor: \(id)")
                index = i
            }
        }
        favTutors.remove(at: index!)
    }
    
    func containsTutor(id: String) -> Bool{
        return student!.favoriteTutors.contains(id)
    }
    
    func getFavs(){
        // search students to find tutors student data
        for tutor in student!.favoriteTutors{
            let tutorStudentInfo = TempDB.shared.searchStudents(id: tutor)
            // find tutor data
            findTutor(id: tutor, studentInfo: tutorStudentInfo!)
        }
    }
    func findTutor(id: String, studentInfo: Student){
        let tutor = TempDB.shared.searchTutor(id: id)
        tutor!.studentInfo = studentInfo
        favTutors.append(tutor!)
    }
    
    func printFavs(){
        var results = ""
        for fav in student!.favoriteTutors{
            results = results + ", \(fav)"
        }
        print(results)
    }
}
