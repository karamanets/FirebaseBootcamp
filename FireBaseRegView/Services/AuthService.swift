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

    private var auth = Auth.auth()

    var currentUser: User? {
        return auth.currentUser
    }

    private init() {}

    func SignIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func SignUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                let UserDB = UserDB(id: result.user.uid, name: "", phone: 0, address: "")
                DataBaseService.shared.setProfile(user: UserDB) { resultDB in
                    
                    switch resultDB {
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
















