//
//  LocationAndCourseView.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/15/22.
//

import SwiftUI

struct LocationAndCourseView: View {
    @State var location: String
    @State var isEditing: Bool = false
    @StateObject var tutorVM = TutorViewModel.shared
    @State var showDialog: Bool = false
    var body: some View {
        VStack{
            HStack{
                Text("Tutoring location: ")
                    .padding(.leading)
                TextField("\(tutorVM.tutor!.location)", text: $location)
                    .padding(.trailing)
                    .foregroundColor(.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            List{
                ForEach(tutorVM.tutor!.courses, id: \.self){ course in
                    CourseRow(isEdit: false, course: course)
                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            .toolbar {
                //                    ToolbarItem(placement: .navigationBarLeading) {
                //                        EditButton()
                //                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        }
        .navigationTitle("Location and Courses")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showDialog, TextAlert(
            title: "Add Course",
            message: ""
        ){ result in
            if let text = result {
                //                tutorVM.addCourse(course: text)
            }
        }
        )
    }
    
    var addButton: some View {
        Button(action: {
            // add to tutor courses
            showDialog.toggle()
        }) {
            Image(systemName: "plus")
        }
    }
    
    func delete(at offsets: IndexSet) {
        TutorViewModel.shared.tutor!.courses.remove(atOffsets: offsets)
    }
}

struct LocationAndCourseView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAndCourseView(location: "")
    }
}
