//
//  AuthService.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 05.01.2023.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    
    private init() { }
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func SingUP(user: String, passwprd: String, completion: @escaping (Result<User, Error>) -> Void ) {
        
        auth.createUser(withEmail: user, password: passwprd) { result, error in
            
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func SingIn(user: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        
        auth.signIn(withEmail: user, password: password) { result, error in
            
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
