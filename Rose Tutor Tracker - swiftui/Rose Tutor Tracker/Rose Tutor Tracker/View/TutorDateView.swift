//
//  TuorDateView.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import SwiftUI

struct TutorDateView: View {
    @State var tutorVM = TutorViewModel.shared.tutor!
    var body: some View {
        NavigationView{
            List($tutorVM.days){ day in
//                AvailabilityRow(isChecked: day.working, startTime: Date(), endTime: Date())
//                AvailabilityRow(day: day.weekday.printDay(), isChecked: day.working)
                AvailabilityRow(day: day)
            }
        }
    }
}

struct TuorDateView_Previews: PreviewProvider {
    static var previews: some View {
        TutorDateView()
    }
}
