//
//  SognIn_Profile.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 16/05/2023.
//

import SwiftUI

//🔥 The same user can't auth twice

struct SignInView_Profile: View {
    
    @ObservedObject var vm: SignInViewModel_Anon
    
    var body: some View {
        List {
            
            Section {
                Button {
                    ///📌 if SignOut then reSignIn -> create a new account (Anon) !
                    try? AuthManager.shared.signOut()
                    withAnimation(.spring()) {
                        vm.isSignIn = false
                    }
                } label: {
                    Text("Sign Out")
                }
            }
            if vm.user?.isAnon == true {
                Section {
                    Button {
                        Task {
                            do {
                                try await vm.linkEmailAccount()
                            } catch let error {
                                print("[⚠️] Error: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Text("Link Email")
                    }
                    
                    Button {
                        Task {
                            do {
                                try await vm.linkGoogleAccount()
                            } catch let error {
                                print("[⚠️] Error: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Text("Link Google")
                    }
                    
                    Button {
                        Task {
                            do {
                                try await vm.linkAppleAccount()
                            } catch let error {
                                print("[⚠️] Error: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Text("Link Apple")
                    }
                } header: {
                    Text("Create Account")
                }
            }
        }
    }
}

//                   🔱
struct SognIn_Profile_Previews: PreviewProvider {
    static var previews: some View {
        SignInView_Profile(vm: SignInViewModel_Anon())
    }
}
