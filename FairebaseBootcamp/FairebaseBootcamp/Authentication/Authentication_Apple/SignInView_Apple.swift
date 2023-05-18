//
//  SignInView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 13/05/2023.
//

import SwiftUI
import AuthenticationServices

struct SignInView_Apple: View {
    
    @StateObject private var vm = SignInViewModel_Apple()
    
    @State private var isSignIn = false
    
    var body: some View {
        
        VStack {
            signInButtonApple_iCloud
            
            signInButtonApple_Firebase
        }
    }
}

//                     🔱
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView_Apple()
    }
}

//MARK: - Component
extension SignInView_Apple {
    
    /// SignIn Button for iCloud
    private var signInButtonApple_iCloud: some View {
        SignInWithAppleButton { _ in
            
        } onCompletion: { _ in
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .padding()
    }
    
    ///SignIn Button for firebase
    private var signInButtonApple_Firebase: some View {
        Button {
            Task {
                do {
                    try await vm.signInApple()
                    isSignIn = true
                } catch let error {
                    print("[⚠️] Error: \(error.localizedDescription)")
                }
            }
        } label: {
            SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                .allowsTightening(false)
        }
        .frame(height: 55)
        .padding()
    }
}
