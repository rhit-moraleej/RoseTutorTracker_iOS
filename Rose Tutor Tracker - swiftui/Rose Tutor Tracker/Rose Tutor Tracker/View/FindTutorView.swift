//
//  FindTutorView.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/14/22.
//

import SwiftUI

struct FindTutorView: View {
    @StateObject var findTutorVM = FindTutorViewModel.shared
    @State var searchTerm: String
    @State var searchType: Int
    
    var body: some View {
        Form{
            HStack{
                searchButton
                TextField("Search by name or course", text: $searchTerm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Picker("", selection: $searchType){
                Text("by Name")
                    .tag(1)
                Text("by Course")
                    .tag(2)
            }
            .pickerStyle(MenuPickerStyle())
            List($findTutorVM.foundTutors){ item in
                TutorRow(tutor: item)
            }
        }
            .navigationTitle("Find A Tutor")
            .navigationBarTitleDisplayMode(.inline)
//        Text("\(searchType)")
        

    }
    
    var searchButton: some View{
        Button {
            findTutorVM.clear()
            findTutorVM.searchBy(searchBy: searchType, searchTerm: searchTerm)
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }
}

//struct FindTutorView_Previews: PreviewProvider {
//    @State var text = "test"
//    static var previews: some View {
//        FindTutorView(searchTerm: text)
//    }
//}
