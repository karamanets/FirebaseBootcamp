//
//  ProfileView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var vm = ProfileViewMode()
    @Binding var showCoreApp: Bool
    
    var body: some View {
        NavigationStack {
            List {
                
                if let user = vm.user {
                    Text("User ID is: \(user.userId)")
                }
                
                if let email = vm.user?.email {
                    Text("Email is: \(email)")
                }
                
                if let isAnon = vm.user?.isAnon {
                    Text("is Anon? \(isAnon.description.capitalized)")
                }
                
                if let date = vm.user?.dateCreated {
                    Text(vm.getDate(date: date))
                }
                
                if let isPremium = vm.user?.isPremium {
                    Text(String(describing: isPremium))
                }
                
                Button {
                    vm.toggleIsPremium()
                } label: {
                    Text("Toggle isPremium Merge")
                }
                
                Button {
                    vm.toggleIsPremium2()
                } label: {
                    Text("Toggle isPremium Single")
                }
            }
            .font(.headline)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCoreApp.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .task {
            try? await vm.loadCurrentUser()
        }
    }
}

//                 🔱
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showCoreApp: .constant(true))
    }
}
