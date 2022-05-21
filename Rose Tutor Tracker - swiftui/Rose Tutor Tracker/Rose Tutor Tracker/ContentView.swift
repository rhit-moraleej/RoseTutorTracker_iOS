//
//  ContentView.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/7/22.
//

import SwiftUI
//import Rosefire
import Firebase

struct ContentView: View {
    @State var result = RosefireResult(token: nil)
    @State private var showingRosefire = true

    @ViewBuilder
    var body: some View {
            VStack{
                if(showingRosefire){
                    ProgressView()
                    .sheet(isPresented: $showingRosefire) {
                        RosefireLogin(roseResult: $result)
                    }
                }
                
                if(!showingRosefire){
//                    ProgressView("Welcome back \n \(result.name)")
//                        .progressViewStyle(CircularProgressViewStyle(tint: Color("RoseRed")))
//                    HomeView()
                }
                
            }
            Spacer()
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
