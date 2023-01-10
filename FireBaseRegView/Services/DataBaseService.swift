//
//  DataBaseService.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 10.01.2023.
//

import Foundation
import FirebaseFirestore

class DataBaseService {
    
    static let shared = DataBaseService()
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private init() {}
    
    func setUser(user: UserDB, completion: @escaping (Result<UserDB, Error>) -> Void ) {
        
        usersRef.document(user.id).setData(user.representation) { error in
            
            if let error = error {
                completion(.failure(error))
            } else  {
                completion(.success(user))
            }
        }
    }
}
