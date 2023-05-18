//
//  CoreRootView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import SwiftUI

struct CoreRootView: View {
    
    @State private var selection = 2
    @Binding var showCoreApp: Bool

    var body: some View {
            TabView(selection: $selection) {
                
                Text("Some")
                    .tabItem {
                        Label("Some View", systemImage: "plus")
                    }.tag(1)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
                
                ProfileView(showCoreApp: $showCoreApp)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill.viewfinder")
                    }.tag(2)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
        }
    }
}

//                  🔱
struct CoreRootView_Previews: PreviewProvider {
    static var previews: some View {
        CoreRootView(showCoreApp: .constant(true))
    }
}
