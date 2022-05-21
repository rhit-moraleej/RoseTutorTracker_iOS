//
//  Student.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/12/22.
//

import Foundation

class Student{
    var name: String = ""
    var email: String = ""
    var major: String = ""
    var classYear: Int = 0
    var favoriteTutors: [String]
    var isTutor: Bool = false
    var hasCompletedSetup: Bool = false
//    var storageUriString: String = ""
    var uid: String = ""
    
    init(name: String, email: String, major: String, classYear: Int, favoriteTutors: [String], isTutor: Bool, hasCompletedSetup: Bool, uid: String){
        self.name = name
        self.email = email
        self.major = major
        self.classYear = classYear
        self.favoriteTutors = favoriteTutors
        self.isTutor = isTutor
        self.hasCompletedSetup = hasCompletedSetup
        self.uid = uid
    }
}
