//
//  AuthenticationManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 12/05/2023.
//

import Foundation
import Firebase

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {}
 
    
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
    
    ///📌  Sign with Google
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInModel) async throws -> AuthManagerModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    private func signIn(credential: AuthCredential) async throws -> AuthManagerModel  {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthManagerModel(user: authDataResult.user)
    }
    
    
}
