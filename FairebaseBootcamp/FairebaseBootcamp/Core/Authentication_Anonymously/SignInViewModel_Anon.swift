//
//  SignInViewModel_Anon.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 16/05/2023.
//

import SwiftUI

@MainActor
final class SignInViewModel_Anon: ObservableObject {
    
    @Published var isSignIn: Bool = false
    @Published var email: String = ""
    @Published var user: AuthManagerModel? = nil
    
    func signInAnonymously() async throws {
        try await AuthManager.shared.signInAnonymously()
    }
    
    func linkGoogleAccount() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        self.user = try await AuthManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkAppleAccount() async throws {
        let helper = SighInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.user = try await AuthManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        /// Email and password from textField
        let email = "Test@test.com"
        let password = "111111"
        self.user = try await AuthManager.shared.linkEmail(email: email, password: password)
    }
    
}
