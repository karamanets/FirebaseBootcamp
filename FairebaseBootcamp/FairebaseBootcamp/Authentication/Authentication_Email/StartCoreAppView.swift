//
//  SomeView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI

struct StartCoreAppView: View {
    
    @ObservedObject var vm: SignInEmailViewModel
    @State var showCoreApp: Bool = false
    
    var body: some View {
        VStack {
            List {
                emailAuth
            }
            Button {
                showCoreApp.toggle()
            } label: {
                Text("Let's Start")
                    .font(.system(size: 28) .bold())
                    .foregroundColor(.white)
            }.buttonMode()
        }
        .fullScreenCover(isPresented: $showCoreApp) {
            CoreRootView(showCoreApp: $showCoreApp)
        }
    }
}

//               🔱
struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StartCoreAppView(vm: SignInEmailViewModel())
        }
    }
}

//MARK: Components
extension StartCoreAppView {
    
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
