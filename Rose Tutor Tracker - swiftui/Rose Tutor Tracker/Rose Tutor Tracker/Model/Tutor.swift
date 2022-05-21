//
//  Tutor.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/12/22.
//

import Foundation

class Tutor: Identifiable{
    
    
    init(available: Bool, courses: [String], location: String, hasCompletedSetup: Bool, uid: String){
        self.available = available
        self.courses = courses
        self.location = location
        self.hasCompletedSetup = hasCompletedSetup
        self.uid = uid
        
        for i in 0..<7 {
            self.days.append(TutorDate(id: i))
        }
        
    }
    var id = UUID()
    var available: Bool = false
    var courses = [String]()
    var location: String = ""
    var hasCompletedSetup: Bool = false
    var uid: String = ""
    var studentInfo: Student?
//    var overRating: Double = 0.0,
//    var numRatings: Int = 0,
    @Published var days = [TutorDate]()
    
    func coursesToString() -> String{
        var result: String = ""
        for course in courses{
            result.append("\t\u{2022} \(course)\n")
        }
        return result
    }
    
    static func == (lhs: Tutor, rhs: Tutor) -> Bool {
        return lhs.uid == rhs.uid
    }
}
