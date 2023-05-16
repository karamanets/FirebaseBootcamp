//
//  AuthenticationEmailView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI

struct SignInEmailRoot: View {
    
    @StateObject private var vm = SignInEmailViewModel()
   
    var body: some View {
        ZStack {
            if vm.isSignIn {
                ProfileView(vm: vm)
                    .transition(.move(edge: .leading))
            } else {
                SignInUpView(vm: vm)
                    .transition(.move(edge: .trailing))
            }
            
        }
        .onAppear {
            /// Check signIn user or not
            let authUser = try? AuthManager.shared.getAuthenticatedUser()
            vm.user = authUser
            vm.email = authUser?.email ?? "" /// for reset func
            vm.isSignIn = authUser == nil ? false : true
            //try? AuthManager.shared.getProvider()
        }
    }
}

//                 🔱
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailRoot()
        }
    }
}



