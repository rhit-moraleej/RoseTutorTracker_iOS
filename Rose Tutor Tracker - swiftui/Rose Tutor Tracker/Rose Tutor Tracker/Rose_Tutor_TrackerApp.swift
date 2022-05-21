//
//  Rose_Tutor_TrackerApp.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 4/7/22.
//

import SwiftUI
import Firebase

@main
struct Rose_Tutor_TrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelgegate
    @StateObject var loggedIn = AuthManager.shared
    @State var loginHandle: AuthStateDidChangeListenerHandle?
    var body: some Scene {
        WindowGroup {
            NavigationView{
                if loggedIn.userSession == nil{
                    //                                HomeView()
                    MainView()
//                    Text("\(AuthManager.shared.userSession)")
//                    LoginView()
//                        .environmentObject(loggedIn)
                }else{
                    
                    //                                ContentView()
//                    LoginView()
                    MainView()
                }
            }
            .navigationViewStyle(.stack)
            .onAppear{
                loginHandle = AuthManager.shared.addLoginObserver {
                    print("")
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
