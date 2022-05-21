//
//  TempDB.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/13/22.
//

import Foundation

class TempDB{
    static let shared = TempDB()
    private init(){
        students = [
            Student(
                name: "Bob Bobert", email: "bob@rose-rulman.edu", major: "CS", classYear: 2022,
                favoriteTutors: [], isTutor: true, hasCompletedSetup: true, uid: "bob"),
            Student(
                name: "Robert GuySon", email: "robert@rose-hulman.edu", major: "MA", classYear: 2023,
                favoriteTutors: [], isTutor: true, hasCompletedSetup: true, uid: "robert"),
            Student(
                name: "Jane Jason", email: "jane@rose-hulman.edu", major: "BA", classYear: 2023,
                favoriteTutors: [], isTutor: true, hasCompletedSetup: true, uid: "jane")
        ]
        tutors = [
            Tutor(available: false, courses: ["CSSE120", "CSSE220", "CSSE230"], location: "Olin 169", hasCompletedSetup: true, uid: "bob"),
            Tutor(available: true, courses: ["MA210"], location: "Olin 159", hasCompletedSetup: true, uid: "robert"),
            Tutor(available: false, courses: ["BA120"], location: "Olin 158", hasCompletedSetup: false, uid: "jane")
        ]
    }
    var students = [Student]()
    var tutors = [Tutor]()
    
    func searchStudents(id: String) -> Student?{
        print("Number of students in TempDB: \(students.count)")
        for student in students {
            print("Looking at: \(student.name)")
            if student.uid == id{
                print("Student found: \(id)")
                return student
            }
        }
        print("could not find \(id)")
        return nil
    }
    
    func searchTutor(id: String) -> Tutor?{
        for tutor in tutors {
            if tutor.uid == id{
                print("Tutor found: \(id)")
                return tutor
            }
        }
        print("could not find \(id)")
        return nil
    }
    
//    func searchCourses(course: )
}
