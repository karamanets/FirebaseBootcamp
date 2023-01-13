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

    func setProfile(user: UserDB, completion: @escaping (Result<UserDB, Error>) -> Void ) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else  {
                completion(.success(user))
            }
        }
    }
    
    func getProfile(completion: @escaping (Result<UserDB, Error>) -> Void ) {
        
        usersRef.document(AuthService.shared.currentUser?.uid ?? "").getDocument { docSnapshot, error in
            guard let snap = docSnapshot else { return }
            guard let data = snap.data() else { return }
            guard let id = data["id"] as? String else { return }
            guard let name = data["name"] as? String else { return }
            guard let phone = data["phone"] as? Int else { return }
            guard let address = data["address"] as? String else { return }
            let user = UserDB(id: id, name: name, phone: phone, address: address)
            completion(.success(user))
        }
    }
}














