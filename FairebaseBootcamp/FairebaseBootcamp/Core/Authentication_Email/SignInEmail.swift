//
//  SignInEmail.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import Foundation


@MainActor
final class SignInEmail: ObservableObject {
    
    @Published var email  = ""
    @Published var password = ""
    @Published var alert = false
    @Published var alertMessage = ""
    @Published var isSignIn = false
    @Published var user: AuthManagerModel? = nil
    
    func signUp() async throws {
        /// Validation
        guard !email.isEmpty, !password.isEmpty else { return }
        
        let returnResult = try await AuthManager.shared.createUser(email: email, password: password)
        user = returnResult
        alert.toggle()
        alertMessage = "[🔥] Success user email is: \(returnResult.email ?? "")"
    }
    
    func signIn() async throws {
        /// Validation
        guard !email.isEmpty, !password.isEmpty else { return }
        
        let returnResult = try await AuthManager.shared.signIn(email: email, password: password)
        user = returnResult
    }
    
    func logOut() throws {
        try AuthManager.shared.signOut()
    }

    func isUserExist() throws -> AuthManagerModel {
        let user = try AuthManager.shared.getAuthenticatedUser()
        return user
    }
    
    func resetPassword() async throws {
        try await AuthManager.shared.resetPassword(email: email)
    }
    
}
