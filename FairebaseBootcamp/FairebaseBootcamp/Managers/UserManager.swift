//
//  UserManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: Created user collection and document just with AuthEmail

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    ///📌 Create new collection - users and document inside with current user profile in Firestore with id from auth
    func createUser(auth: AuthUserModel) async throws {
        
        var userData: [String: Any] = [
            "user_id"    : auth.uid,
            "is_anon"    : auth.isAnon,
            "date_create": Timestamp()
        ]
        ///🔥 email and photoUrl is optional
        if let email = auth.email {
            userData["email"] = email
        }
        if let photoUrl = auth.photoUrl {
            userData["photo_url"] = photoUrl
        }
        ///🔥 if collection and user exist -> add if not -> create
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    ///📌 Get user portfolio from collection users in firestore use snapshot
    func getUser(userID: String) async throws -> DBUserModel {
        
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        
        guard
            let data = snapshot.data(),
            let userID = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let isAnon   = data["is_anon"] as? Bool
        let email    = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let date     = data["date_create"] as? Date
        
        return DBUserModel(userID: userID, isAnon: isAnon, email: email, photoUrl: photoUrl, dateCreated: date)
    }
}
