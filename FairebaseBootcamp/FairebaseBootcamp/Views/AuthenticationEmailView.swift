//
//  AuthenticationEmailView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI

struct AuthenticationEmailView: View {
    
    @StateObject private var vm = SignInEmail()
   
    var body: some View {
        ZStack {
            if vm.isSignIn {
                ProfileView(vm: vm)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .leading))
            } else {
                SignInUp(vm: vm)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .trailing))
            }
            
        }
        .onAppear {
            /// Check signIn user or not
            let authUser = try? AuthManagerEmail.shared.getAuthenticatedUser()
            vm.user = authUser
            vm.isSignIn = authUser == nil ? false : true
        }
    }
}

//                 🔱
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationEmailView()
        }
    }
}



