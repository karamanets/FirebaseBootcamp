//
//  FairebaseBootcampApp.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI
import Firebase

@main
struct FairebaseBootcampApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FirebaseApp.configure()
      
    return true
  }
}
