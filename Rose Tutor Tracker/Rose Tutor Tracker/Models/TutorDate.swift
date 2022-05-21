//
//  TutorDate.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import Foundation

// TODO: get TutorDate to work
enum Day: Int {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday
    
    func printDay() -> String{
        switch self{
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }
}

struct TutorDate: Codable{

    var working: Bool
    var startHour: Int
    var startMin: Int
    var endHour: Int
    var endMin: Int
    var day: String

}
