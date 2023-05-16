//
//  SomeView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var vm: SignInEmailViewModel
    
    var body: some View {
            List {
                emailAuth
            }
    }
}

//               🔱
struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(vm: SignInEmailViewModel())
        }
    }
}

//MARK: Components
extension ProfileView {
    
    private var emailAuth: some View {
        Section {
            /// LogOut
            Button {
                Task {
                    do {
                        try vm.logOut()
                        withAnimation(.spring()) {
                            vm.isSignIn = false
                            vm.user = nil
                        }
                    } catch {
                        print("[⚠️] Error logOut")
                    }
                }
            } label: {
                Text("SignOut")
            }
            
            ///Reset Password
            Button {
                Task {
                    do {
                        try await vm.resetPassword()
                        print("[⚠️] Reset Success")
                    } catch {
                        print("[⚠️] Error Reset")
                    }
                }
            } label: {
                Text("Reset Password")
            }
            
        } header: {
            Text("Email Auth")
        }
    }
}
