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
    
    func createUser(email: String, password: String) async throws -> AuthManagerEmailModel {
        
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        return AuthManagerEmailModel(user: authResult.user)
    }
}

/// Model
struct AuthManagerEmailModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        
        ///user.isAnonymous
        ///user.phoneNumber
        ///...
    }
}
