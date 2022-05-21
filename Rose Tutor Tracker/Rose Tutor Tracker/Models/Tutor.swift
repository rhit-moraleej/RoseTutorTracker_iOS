//
//  Tutor.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/12/22.
//

import Foundation
import FirebaseFirestoreSwift
import AVFoundation

struct Tutor: Codable {
    @DocumentID var id : String?
    var available: Bool
    var courses = [String]()
    var location: String
    var hasCompletedSetup: Bool
    var days: [TutorDate]
    var studentInfo: Student?
    var numRatings: Int?
    var overRating: Int?
    
    func coursesToString() -> String{
        var result = "Courses: \n"
        print(courses)
        for course in courses {
            print(course)
            result += "\t\u{2022} \(course)\n"
        }
        return result
    }
    
    func daysToString() -> String {
        var result = "Available: \n"
        for day in days {
            if day.working {
                let start = String(format: "%02d:%02d", day.startHour, day.startMin)
                let end = String(format: "%02d:%02d", day.endHour, day.endMin)
                let line = String(format: "\t\u{2022} %@: \t\t\t%@ - %@\n", day.day, start, end)
                result += line
            }
        }
        return result
    }
    
    func checkAvalability() -> Bool {
        let weekday = Calendar.current.component(.weekday, from: Date())
        let index = (weekday + 5)%7 // iOS numbers day from 1 - 7 starting with Sunday. I store days in arrays, with day 0 being Monday.
        print("Day of week: \(weekday)")
        print("Corrected index: \(index)")
        if days[index].working{
            print("tutor is working today")
            print("From \(days[index].startHour) to \(days[index].endHour)")
            let now = Date()
            print("Current time : \(now)")
            let start  = Calendar.current.date(bySettingHour: days[index].startHour, minute: days[index].startMin, second: 0, of: Date())!
            print("Start Time: \(start)")
            let end  = Calendar.current.date(bySettingHour: days[index].endHour, minute: days[index].endMin, second: 0, of: Date())!
            print("End Time: \(end)")
            
            return (now < end) && (now >= start)
        }
        return false
    }
}
