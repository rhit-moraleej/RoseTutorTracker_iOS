//
//  TutotViewModel.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/15/22.
//

import Foundation

class TutorViewModel: ObservableObject{
    static let shared = TutorViewModel()
    @Published var tutor: Tutor?
    private init(){
        tutor = Tutor(
            available: false,
            courses: ["CSSE120", "CSSE220", "CSSE304"],
            location: "Your mom's house",
            hasCompletedSetup: true,
            uid: "moraleej")
    }
    
    func addCourse(course: String){
//        if tutor!.courses.last != ""{
//            tutor!.courses.append("")
//        }
        tutor!.courses.append(course)
        print(tutor!.courses)
    }
    
    func updateTutorCourses(list: [String]){
        // update firebase with tutors course list
        tutor!.courses = list
    }
}
