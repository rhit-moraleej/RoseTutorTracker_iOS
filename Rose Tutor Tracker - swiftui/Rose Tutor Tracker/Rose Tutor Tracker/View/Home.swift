//
//  Home.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/9/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var studentVM = StudentViewModel.shared
    var body: some View {
        VStack{
            Text("Your Favorite Tutors:")
                .padding()
            List{
                ForEach($studentVM.favTutors){ item in
                    TutorRow(tutor: item)
                        
                }
                //                    .onDrag(<#T##data: () -> NSItemProvider##() -> NSItemProvider#>)
            }.listStyle(.grouped)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
