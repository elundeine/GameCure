//
//  CauseCureApp.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI
import Firebase

@main
struct CauseCureApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SessionStore())
                .environmentObject(SharedInt())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Firebase...")
        FirebaseApp.configure()
        
        return true
    }
}

class SharedInt: ObservableObject {
    @Published var myInt = 0
}
