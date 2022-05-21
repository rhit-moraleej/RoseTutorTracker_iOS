//
//  SettingView.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @StateObject var studentVM = StudentViewModel.shared
    var body: some View {
        VStack{
            Image(systemName: "person")
                .resizable()
                .frame(width: 150, height: 150)
            Text("\(studentVM.student!.name)")
            Text("\(studentVM.student!.email)")
            Form{
                Section ("Student Settings"){
                    NavigationLink {
                        UserDetails(
                            navTitle: "Update User Details",
                            classYear: "\(studentVM.student!.classYear)",
                            major: "\(studentVM.student!.major)")
                    } label: {
                        Text("Update User Details")
                    }
                }
                if studentVM.student!.isTutor{
                    Section("Tutor Settings"){
                        NavigationLink {
                            LocationAndCourseView(location: "")
                        } label: {
                            Text("Update Courses and Location")
                        }
                        NavigationLink {
                            TutorDateView()
                        } label: {
                            Text("Update Availability")
                        }
                    }
                }
                Section{
                    Button {
                        AuthManager.shared.signOut()
                        UserDefaults.standard.set(true, forKey: UserData.loggedIn)
                        print("loggin out")
                    } label: {
                        Text("Log Out")
                            .foregroundColor(.black)
                    }
                    
                }
            }
            .navigationTitle("Settings")
        }
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
