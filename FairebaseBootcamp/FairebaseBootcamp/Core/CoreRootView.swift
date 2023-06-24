//
//  CoreRootView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import SwiftUI

struct CoreRootView: View {
    
    @State private var selection = 6
    @Binding var showCoreApp: Bool

    var body: some View {
            TabView(selection: $selection) {
                
                ProductsView()
                    .tabItem {
                        Label("Products 1", systemImage: "cart.fill")
                    }.tag(1)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
                
                StorageView()
                    .tabItem {
                        Label("Storage", systemImage: "server.rack")
                    }.tag(2)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
                
                FavoriteView()
                    .tabItem {
                        Label("Favorite", systemImage: "star.square.on.square.fill")
                    }.tag(3)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
                
                ProfileView(showCoreApp: $showCoreApp)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill.viewfinder")
                    }.tag(4)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
                
                ProductsView_2()
                    .tabItem {
                        Label("Products 2", systemImage: "cart.fill")
                    }.tag(5)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
                
                CrashlyticsView()
                    .tabItem {
                        Label("Crash", systemImage: "paperplane.circle.fill")
                    }.tag(6)
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
