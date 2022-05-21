//
//  TutorDetails.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/12/22.
//

import SwiftUI

struct TutorDetails: View {
    @Binding var tutor: Tutor
    @State var isFavorite: Bool
    var body: some View {
        NavigationView{
            VStack{
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 150, height: 150)
                HStack{
                    Text("Name: \(tutor.studentInfo!.name)")
                        .frame(alignment: .leading)
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("Email: \(tutor.studentInfo!.email)")
                        .frame(alignment: .leading)
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("Class of \(String(tutor.studentInfo!.classYear))")
                        .frame(alignment: .leading)
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("Courses:")
                        .frame(alignment: .leading)
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    Text(tutor.coursesToString())
                        .frame(alignment: .leading)
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("Location: \(tutor.location)")
                        .frame(alignment: .leading)
                        .padding(.leading)
                    Spacer()
                }
                HStack{
//                    Spacer()
                    favButton
                        .background(Color("RoseRed").cornerRadius(8))
                        .foregroundColor(.white)
                        .frame(alignment: .leading)
//                        .padding(.leading)
                        .padding()
                    Spacer()
                    notifyButton
                        .background(Color("RoseRed").cornerRadius(8))
                        .foregroundColor(.white)
                        .frame(alignment: .trailing)
                        .padding(.trailing)
//                    Spacer()
                }
                
            }
        }
        .navigationTitle("Favortite Tutor")
    }
    
    var favButton: some View {
        Button {
            if(isFavorite){
                StudentViewModel.shared.removeTutor(id: tutor.uid)
                StudentViewModel.shared.printFavs()
                isFavorite.toggle()
            }else{
                StudentViewModel.shared.addTutor(tutor: tutor)
                isFavorite.toggle()
            }
        } label: {
            if isFavorite{
                Text("Unfavorite")
            } else{
                Text("Favorite")
            }
        }
        .padding()
    }
    
    var notifyButton: some View {
        Button{
//            if(tutor.available){
//
//            }
        } label: {
            Text("Notify")
        }
        .padding()
    }
}

//struct TutorDetails_Previews: PreviewProvider {
//    var tutor: Tutor = StudentViewModel.shared.favTutors[0]
//    static var previews: some View {
//        TutorDetails(tutor: tutor, isFavorite: true)
//    }
//}
