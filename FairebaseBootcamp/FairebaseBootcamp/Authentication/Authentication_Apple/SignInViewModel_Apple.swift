//
//  SignInViewModel_Apple.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 13/05/2023.
//

import Foundation

@MainActor
final class SignInViewModel_Apple: ObservableObject {
    
    let signInAppleHelper = SighInAppleHelper()
    
    func signInApple() async throws {
        let helper = SighInAppleHelper()
        let token = try await helper.startSignInWithAppleFlow()
        try await AuthManager.shared.signInWithApple(tokens: token)
    }
}


