//
//  TutorRow.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/12/22.
//

import SwiftUI

struct TutorRow: View {
    @Binding var tutor: Tutor
    var body: some View {
        NavigationLink(destination: TutorDetails(tutor: $tutor, isFavorite: StudentViewModel.shared.containsTutor(id: tutor.uid))) {
            VStack{
                HStack{
                    Text(tutor.studentInfo!.name)
                        .frame(alignment: .leading)
                    Spacer()
                }
                HStack{
                    Text("Major: \(tutor.studentInfo!.major)")
                        .frame(alignment: .leading)
                    Spacer()
                    if(tutor.available){
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .frame(alignment: .trailing)
                    }else{
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .frame(alignment: .trailing)
                    }
                    
                }
                HStack{
                    Text("Location: \(tutor.location)")
                        .frame(alignment: .leading)
                    Spacer()
                }
            }.frame(width: 200, height: 60, alignment: .leading)
            
        }
    }
}

//struct TutorRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorRow(tutor: Tutor(available: <#T##Bool#>, courses: <#T##[String]#>, location: <#T##String#>, hasCompletedSetup: <#T##Bool#>, uid: <#T##String#>))
//    }
//}
