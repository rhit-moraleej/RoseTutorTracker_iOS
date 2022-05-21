//
//  UserDetails.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import SwiftUI

struct UserDetails: View {
    @StateObject var studentVM = StudentViewModel.shared
    @State var navTitle: String
    @State var classYear: String
    @State var major: String
    var body: some View {
        VStack{
            Image(systemName: "person")
                .resizable()
                .frame(width: 150, height: 150)
            uploadButton
                .background(Color("RoseRed").cornerRadius(8))
                .foregroundColor(.white)
                .padding()
            HStack{
                Text("Name: \(studentVM.student!.name)")
                    .frame(alignment: .leading)
                    .padding(.leading)
                Spacer()
            }
            HStack{
                Text("Email: \(studentVM.student!.email)")
                    .frame(alignment: .leading)
                    .padding(.leading)
                Spacer()
            }
            HStack{
                Text("Class: ")
                    .frame(alignment: .leading)
                    .padding(.leading)
                TextField("\(String(studentVM.student!.classYear))", text: $classYear)
                    .foregroundColor(.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }
            HStack{
                Text("Major: ")
                    .frame(alignment: .leading)
                    .padding(.leading)
                TextField("\(String(studentVM.student!.major))", text: $major)
                    .foregroundColor(.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }
            updateButton
                .background(Color("RoseRed").cornerRadius(8))
                .foregroundColor(.white)
                .padding()
        }
        .navigationTitle("\(navTitle)")
        .navigationBarTitleDisplayMode(.automatic)
    }
    
    var uploadButton: some View {
        Button {
            // open image picker/ camera
        } label: {
            Text("Upload Photo")
        }
        .padding()
    }
    
    var updateButton: some View {
        Button {
            // update student data
        } label: {
            Text("update Profile")
        }
        .padding()
    }
}

struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserDetails(navTitle: "", classYear: "", major: "")
    }
}
