//
//  AvailabilityRow.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import SwiftUI

struct AvailabilityRow: View {
    @Binding var day: TutorDate
//    var day: String
//    @State var isChecked: Bool
//    @State var startTime = Date()
//    @State var endTime = Date()
    var body: some View {
        VStack{
            Toggle(isOn: $day.working) {
                Text("\(day.weekday.printDay())")
            }
            if day.working{
                HStack{
//                    DatePicker("From:", selection: $startTime, displayedComponents: .hourAndMinute)
////                    Text("to")
//                    DatePicker("To:", selection: $endTime, displayedComponents: .hourAndMinute)
                }
            }
        }
    }
}

//struct AvailabilityRow_Previews: PreviewProvider {
//    static var previews: some View {
//        AvailabilityRow(isChecked: false, startTime: Date(), endTime: Date())
//    }
//}
