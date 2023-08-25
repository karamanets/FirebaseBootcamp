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
    func createUser(email: String, password: String) async throws -> AuthUserModel {
        
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        return AuthUserModel(user: authResult.user)
    }
    
    ///📌  SignIn -> if user already exist
    func signIn(email: String, password: String) async throws -> AuthUserModel {
        
        let signInResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return AuthUserModel(user: signInResult.user)
    }
    
    ///📌  Get user authenticated or not (is not async just local)
    func getAuthenticatedUser() throws -> AuthUserModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthUserModel(user: user)
    }
    
    ///📌  Sign Out (is not async just local)
    func signOut() throws {
       try Auth.auth().signOut()
    }
    
    ///📌 Check exist user for this email or not
    func checkUserExistsInAuthentication(email: String) async throws -> Bool {
        let result = try await Auth.auth().fetchSignInMethods(forEmail: email)
        return result.count > 0
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
    
    ///📌 Delete User / Account -> must have opportunity to delete account etch user (First show alert and then re-signIn to be sure )
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
    }
    
    //MARK: Google
    ///📌 For SignIn Google and Apple
    private func signIn(credential: AuthCredential) async throws -> AuthUserModel  {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthUserModel(user: authDataResult.user)
    }
    
    ///📌  Sign with Google
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInModel) async throws -> AuthUserModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    //MARK: Apple
    ///📌  Sign with Apple
    @discardableResult
    func signInWithApple(tokens: SignInWithResult) async throws -> AuthUserModel {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOptions.apple.rawValue , idToken: tokens.token, accessToken: tokens.nonce)
        return try await signIn(credential: credential)
    }
    
    //MARK: Anonymously
    ///📌 SignIn Anonymously
    @discardableResult
    func signInAnonymously() async throws -> AuthUserModel {
        
        let signInResult = try await Auth.auth().signInAnonymously()
        
        return AuthUserModel(user: signInResult.user)
    }
    
    ///📌 Get Credential
    private func linkCredential(credential: AuthCredential) async throws -> AuthUserModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        let authDataResult = try await user.link(with: credential)
        
        return AuthUserModel(user: authDataResult.user)
    }
    
    ///📌 Link User from Anon Account -> to Auth Account - Email
    func linkEmail(email: String, password: String) async throws -> AuthUserModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkCredential(credential: credential)
    }
    
    ///📌 Link User from Anon Account -> to Auth Account - Apple
    func linkApple(tokens: SignInWithResult) async throws -> AuthUserModel {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOptions.apple.rawValue , idToken: tokens.token, accessToken: tokens.nonce)
        return try await linkCredential(credential: credential)
    }
    
    ///📌 Link User from Anon Account -> to Auth Account - Google
    func linkGoogle(tokens: GoogleSignInModel) async throws -> AuthUserModel {
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
