//
//  SignInViewRoot.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 16/05/2023.
//

import SwiftUI

struct SignInViewRoot: View {
    
    @StateObject private var vm = SignInViewModel_Anon()
    
    var body: some View {
        ZStack {
            if vm.isSignIn {
                SignInView_Profile(vm: vm)
                    .transition(.move(edge: .trailing))
            } else {
                SignInView_Anon(vm: vm)
                    .transition(.move(edge: .leading))
            }
        }
        .onAppear {
            let authUser = try? AuthManager.shared.getAuthenticatedUser()
            vm.user = authUser
            vm.email = authUser?.email ?? "" /// for reset func
            vm.isSignIn = authUser == nil ? false : true
        }
    }
}

//                  🔱
struct SignInView_Anonymously_Previews: PreviewProvider {
    static var previews: some View {
        SignInViewRoot()
    }
}

//MARK: Component
extension SignInViewRoot {
    
    /// Button View
    private var buttonView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.mint)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
            Text("Sign In")
                .foregroundColor(.white)
                .font(.system(size: 19))
        }
        .padding(.horizontal)
    }
}
