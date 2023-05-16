//
//  AuthManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    //MARK: Email
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
    @discardableResult
    func getProvider() throws -> [AuthProviderOptions] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOptions] = []
        for provider in providerData {
            if let option = AuthProviderOptions(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("[⚠️] Provider option not found: \(provider.providerID)")
            }
            print("[🔥] provider: \(provider.providerID)")
        }
        return providers
    }
    
    //MARK: Google
    ///📌 For SignIn Google and Apple
    private func signIn(credential: AuthCredential) async throws -> AuthManagerModel  {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthManagerModel(user: authDataResult.user)
    }
    
    ///📌  Sign with Google
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInModel) async throws -> AuthManagerModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    //MARK: Apple
    ///📌  Sign with Apple
    @discardableResult
    func signInWithApple(tokens: SignInWithResult) async throws -> AuthManagerModel {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOptions.apple.rawValue , idToken: tokens.token, accessToken: tokens.nonce)
        return try await signIn(credential: credential)
    }
    
    //MARK: Anonymously
    ///📌 SignIn Anonymously
    @discardableResult
    func signInAnonymously() async throws -> AuthManagerModel {
        
        let signInResult = try await Auth.auth().signInAnonymously()
        
        return AuthManagerModel(user: signInResult.user)
    }
    
    ///📌 Get Credential
    private func linkCredential(credential: AuthCredential) async throws -> AuthManagerModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        let authDataResult = try await user.link(with: credential)
        
        return AuthManagerModel(user: authDataResult.user)
    }
    
    ///📌 Link User from Anon Account -> to Auth Account - Email
    func linkEmail(email: String, password: String) async throws -> AuthManagerModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkCredential(credential: credential)
    }
    
    ///📌 Link User from Anon Account -> to Auth Account - Apple
    func linkApple(tokens: SignInWithResult) async throws -> AuthManagerModel {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOptions.apple.rawValue , idToken: tokens.token, accessToken: tokens.nonce)
        return try await linkCredential(credential: credential)
    }
    
    ///📌 Link User from Anon Account -> to Auth Account - Google
    func linkGoogle(tokens: GoogleSignInModel) async throws -> AuthManagerModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkCredential(credential: credential)
    }
    
}

//MARK: Providers
enum AuthProviderOptions: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}
