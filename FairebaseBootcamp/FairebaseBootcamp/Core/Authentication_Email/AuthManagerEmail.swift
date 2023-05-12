//
//  AuthManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import Foundation
import FirebaseAuth

final class AuthManagerEmail {
    
    static let shared = AuthManagerEmail()
    
    private init() {}
    
    ///📌 Create user with email
    func createUser(email: String, password: String) async throws -> AuthManagerModel {
        
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        return AuthManagerModel(user: authResult.user)
    }
    
    ///📌  SignIn -> if user already exist
    func signIn(email: String, password: String) async throws -> AuthManagerModel {
        
        let signInResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return AuthManagerModel(user: signInResult.user)
    }
    
    ///📌  Get user authenticated or not (is not async just local)
    func getAuthenticatedUser() throws -> AuthManagerModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthManagerModel(user: user)
    }
    
    ///📌  Sign Out (is not async just local)
    func signOut() throws {
       try Auth.auth().signOut()
    }
    
    ///📌  Reset Password
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    ///📌 Chang user email
    func updateEmail(email: String) async throws {
        
        /// CurrentUser is not async just local
        guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse )}
        
        try await user.updateEmail(to: email)
    }
    
    ///📌 Change user password
    func updatePassword(pass: String) async throws {
        
        /// CurrentUser is not async just local
        guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse )}
        
        try await user.updatePassword(to: pass)
    }
    
    ///📌 User can use deferent Provider to signIn
    func getProvider() throws {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        for provider in providerData {
            print("[🔥] provider: \(provider.providerID)")
        }
    }
}


