//
//  TutorDate.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import Foundation

class TutorDate: Identifiable, ObservableObject{
    enum Day: Int {
        case sunday = 0, monday, tuesday, wednesday, thursday, friday, saturday
        
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
    var working: Bool = false
    var startHour: Int = 0
    var startMin: Int = 0
    var endHour: Int = 0
    var endMin: Int = 0
    var weekday: Day
    var id: Int
    init(id: Int){
        self.id = id
        self.weekday = Day(rawValue: id)!
    }
    
    init(id: Int, working: Bool, startTime: Date, endTime: Date){
        self.working = working
        // get hour and minute from start time
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startTime)
        let min = calendar.component(.minute, from: startTime)
        self.startHour = hour
        self.startMin = min
        // get hour and minute from end time
        let hour2 = calendar.component(.hour, from: endTime)
        let min2 = calendar.component(.minute, from: endTime)
        self.endHour = hour2
        self.endMin = min2

        self.id = id
        self.weekday = Day(rawValue: id)!
//        self.startHour = Calendar.Component(.hour, from: startTime)
//        self.startMin = Calendar.Component(.minute, from: startTime)
//        self.endHour = Calendar.Component(.hour, from: endTime)
//        self.endMin = Calendar.Component(.minute, from: endTime)
    }
}
