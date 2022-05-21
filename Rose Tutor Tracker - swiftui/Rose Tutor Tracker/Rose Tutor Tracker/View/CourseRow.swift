//
//  CourseRow.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/15/22.
//

import SwiftUI

struct CourseRow: View {
    @State var isEdit: Bool
    @State var course: String
    var body: some View {
        if isEdit{
            TextField("\(course)", text: $course)
                .foregroundColor(.black)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }else{
            Text("\(course)")
        }
    }
}

struct CourseRow_Previews: PreviewProvider {
    static var previews: some View {
        CourseRow(isEdit: true, course: "Test")
    }
}
