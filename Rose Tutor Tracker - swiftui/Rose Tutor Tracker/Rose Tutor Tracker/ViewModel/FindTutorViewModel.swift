//
//  FindTutorViewModel.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import SwiftUI

class FindTutorViewModel: ObservableObject{
    static let shared = FindTutorViewModel()
    @Published var foundTutors = [Tutor]()
    
    private init(){
        
    }
    
    func clear(){
        foundTutors.removeAll()
    }
    
    func searchBy(searchBy: Int, searchTerm: String){
        switch searchBy{
        case 1:
            // might need to sanitize input
            searchByName(searchTerm: searchTerm)
            break
            
        case 2:
            let term = searchTerm.uppercased()
            searchByCourse(searchTerm: term)
            break
        default:
                print("invalid choice?")
        }
    }
    
    func searchByName(searchTerm: String){
        for student in TempDB.shared.students{
            if student.isTutor && student.name.starts(with: searchTerm){
                searchTutor(student: student)
            }
        }
    }
    
    func searchByCourse(searchTerm: String){
        print("SearchTerm: \(searchTerm)")
        for tutor in TempDB.shared.tutors{
            print("Lookig at Tutor: \(tutor.uid)")
            if tutor.hasCompletedSetup{
                for course in tutor.courses{
                    print("Looking at course: \(course)")
                    if course == searchTerm{
                        searchStudent(tutor: tutor)
                    }
                }
            }
        }
    }
    
    func searchTutor(student: Student){
        if let tutor = TempDB.shared.searchTutor(id: student.uid){
            tutor.studentInfo = student
            foundTutors.append(tutor)
        }
    }
    
    func searchStudent(tutor: Tutor){
        if let student = TempDB.shared.searchStudents(id: tutor.uid){
            tutor.studentInfo = student
            foundTutors.append(tutor)
        }
    }
}
