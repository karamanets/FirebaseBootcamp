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
    
    ///📌 Path to users collection
    private let userCollection = Firestore.firestore().collection("users")
    
    ///📌 Path user document with userID
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    ///📌 Make key style SnakeCase : user_id  (from 10.0.0 ver. Firebase)
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    ///📌 Make key style SnakeCase : user_id  (from 10.0.0 ver. Firebase)
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
        
    ///📌 Create new collection - users and document inside with current user profile in Firestore with id from auth  (codable protocol)
    func createUser(user: DBUserModel) async throws {
        ///Example with Snake style : user_id
        //try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
        
        /// Example with CodingKeys
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
        
    ///📌 Get user document from users collection (codable protocol)
    func getUser(user: String) async throws -> DBUserModel {
        try await userDocument(userId: user).getDocument(as: DBUserModel.self)
    }
    
    ///📌  Update data with merge -> set all user data
    func updateUserIsPremiumStatus(user: DBUserModel) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    
    ///📌  Update data with single value - is more safe
    func updateUserIsPremiumStatusSingle(userId: String, isPremium: Bool) async throws {
        
        ///Key must be the same lake encoder
        let data: [String: Any] = [
            DBUserModel.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    ///📌 Update data Array (append) new Element
    func updatePreferenceArray(userId: String, preference: String) async throws {
        
        /// Instead set all array -> just add new value use -> FieldValue.arrayUnion
        let data: [String: Any] = [
            DBUserModel.CodingKeys.preference.rawValue : FieldValue.arrayUnion([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    ///📌 Remove data Array (remove)  Element
    func removePreferenceArray(userId: String, preference: String) async throws {
        
        /// Instead set all array -> just add new value use -> FieldValue.arrayUnion
        let data: [String: Any] = [
            DBUserModel.CodingKeys.preference.rawValue : FieldValue.arrayRemove([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    ///📌 Update user Document with  -> Custom mapData
    func updateGame(userId: String, game: Games) async throws {
        
        guard let data = try? encoder.encode(game) else {
            throw URLError(.badURL)
        }
        /// Add custom struct
        let dict: [String: Any] = [
            DBUserModel.CodingKeys.game.rawValue : data
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    
    ///📌 Remove in user document -> Document with  Custom mapData
    func removeGame(userId: String) async throws {
        
        /// Remove custom struct
        let dict: [String: Any?] = [
            DBUserModel.CodingKeys.game.rawValue : nil
        ]
        try await userDocument(userId: userId).updateData(dict as [AnyHashable: Any])
    }
    
}
