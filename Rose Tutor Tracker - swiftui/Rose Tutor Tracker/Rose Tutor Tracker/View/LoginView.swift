//
//  LoginView.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/17/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var loggedIn: AuthManager
    @State var result = RosefireResult(token: nil)
    @State private var showingRosefire = false
    @State private var log = Auth.auth().currentUser
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    init(){
        loginHandle = AuthManager.shared.addLoginObserver {
            print("finally logged in")
        }
    }
    var body: some View {
        Group{
            if log == nil {
                loginView
            } else {
                MainView()
            }
        }
    }
}

extension LoginView {
    var loginView: some View {
        VStack{
            Button("Login with Rosefire"){
                showingRosefire.toggle()
            }
            .foregroundColor(.white)
            .padding(20)
            .background(Color("RoseRed").cornerRadius(5))
            }
        .sheet(isPresented: $showingRosefire){
            RosefireLogin(roseResult: $result)
                .environmentObject(loggedIn)
                .onAppear{
                    
                }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
