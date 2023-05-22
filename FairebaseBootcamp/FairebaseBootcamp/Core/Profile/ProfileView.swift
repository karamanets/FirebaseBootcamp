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
    
    /// Same Value -> Just a bit hard code )
    let preference = ["Sport", "Films", "Coding"]
    
    /// Some data
    let game = Games(id: "12", name: "Lineage 2", top: true)
    
    private func preferenceSelected(text: String) -> Bool {
        vm.user?.preference?.contains(text) == true
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                VStack (alignment: .leading){
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
                        Text("isPremium: \(String(describing: isPremium))")
                    }
                }
                
                
                HStack {
                    Button {
                        vm.toggleIsPremium()
                    } label: {
                        Text("Toggle isPremium Merge")
                            .font(.system(size: 15))
                    }.buttonStyle(.borderedProminent)
                    
                    Button {
                        vm.toggleIsPremium2()
                    } label: {
                        Text("Toggle isPremium Single")
                            .font(.system(size: 15))
                    }.buttonStyle(.borderedProminent)
                }
                
                HStack {
                    ForEach(preference, id: \.self) { string in
                        Button {
                            if preferenceSelected(text: string) {
                                vm.removePreference(value: string)
                            } else {
                                vm.updatePreference(value: string)
                            }
                        } label: {
                            Text(string)
                                .font(.system(size: 15))
                        }.buttonStyle(.borderedProminent)
                            .tint(preferenceSelected(text: string) ? .green : .red)
                    }
                    
                }
                
                VStack {
                    if let preference = vm.user?.preference {
                        Text(String(describing: preference))
                    }
                }
                
                VStack {
                    Button {
                        if vm.user?.game == nil {
                            vm.updateGame(game: game)
                        } else {
                            vm.removeGame()
                        }
                    } label: {
                        Text("Add/Remove Game")
                            .font(.system(size: 15))
                    }.buttonStyle(.borderedProminent)
                }
                
                HStack {
                    if vm.user?.game != nil {
                        Text(String(describing: vm.user?.game?.name))
                    }
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
