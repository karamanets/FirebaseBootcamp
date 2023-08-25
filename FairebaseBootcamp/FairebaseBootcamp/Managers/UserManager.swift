//
//  UserManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//MARK: Created user collection and document just with AuthEmail

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    ///📌 Path to users collection
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
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
            DBUserModel.CodingKeys.isPremium.rawValue : isPremium,
            //"custom_key" : "777" // for firestore rile
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    ///📌 Add imagePath from FirebaseStorage to user profile
    func updateUserImagePath(userId: String, path: String?) async throws {
        
        ///Key must be the same lake encoder
        let data: [String: Any] = [
            DBUserModel.CodingKeys.profileImagePath.rawValue : path as Any,
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    ///📌   Add imageURL from FirebaseStorage to user profile
    func updateUserImageUrl(userId: String, url: String?) async throws {
        
        ///Key must be the same lake encoder
        let data: [String: Any] = [
            DBUserModel.CodingKeys.profileImagePathUrl.rawValue : url as Any,
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
    
    //MARK: SubCollection for user
    
    ///📌  Add subCollection in user document use user's ID
    private func userFavouriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favourite_product")
    }
    
    ///📌 Generate document use id
    private func userFavouriteProductDocument(userId: String, favouriteProductId: String) -> DocumentReference {
        userFavouriteProductCollection(userId: userId).document(favouriteProductId)
    }
    
    ///📌 Add Favorite product to subCollection in collection users -> user document. Also this setUp allowed add the same product because documentID -> generate random (.document())
    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        /// setUp random id for Favorite product in user subCollection
        let document = userFavouriteProductCollection(userId: userId).document()
        /// Get ID of blanc document first
        let documentId = document.documentID
        
        let data: [String: Any] = [
            UserFavoriteModel.CodingKeys.id.rawValue : documentId,
            UserFavoriteModel.CodingKeys.productId.rawValue : productId,
            UserFavoriteModel.CodingKeys.date.rawValue : Timestamp()
        ]
        ///SetUp data in user subCollection
        try await document.setData(data, merge: false)
    }
    
    ///📌  Remove Favorite product from user subCollection
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavouriteProductDocument(userId: userId, favouriteProductId: favoriteProductId).delete()
    }
    
    ///📌 Get All favorite products from user subCollection
    func getAllFavoriteUserProduct(userId: String) async throws -> [UserFavoriteModel] {
        try await userFavouriteProductCollection(userId: userId).getAllDocumentsGeneric(as: UserFavoriteModel.self)
    }
    
    //MARK: Listener
    
    ///📌 Store listener
    private var userFavoriteProductListener: ListenerRegistration? = nil
    
    ///📌 Cancel listener for favorites
    private func removeListenerForAllFavoriteProducts() {
        self.userFavoriteProductListener?.remove()
    }
    
    ///📌 Example 1 - Add listener -> all time when data will change in firestore it will be update immediately use - completion
    func addListenerFavoriteUserProduct(userId: String, completion: @escaping (_ product: [UserFavoriteModel] ) -> Void) {
        self.userFavoriteProductListener = userFavouriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else {
                print("[⚠️] Error: no data")
                return
            }
            let product: [UserFavoriteModel] = document.compactMap({ try? $0.data(as: UserFavoriteModel.self) })
            completion(product)
            
            /// Get real-time access
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("[🔥] New Product \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("[🔥] Modified Product \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("[🔥] Removed Product \(diff.document.data())")
                }
            }
        }
    }
 
    ///📌 Example 2 - Add listener -> all time when data will change in firestore it will be update immediately use - Publisher instead completion
    func addListenerFavoriteUserProductUseCustomPublisher(userId: String) -> AnyPublisher<[UserFavoriteModel], Error> {
        
        let publisher = PassthroughSubject<[UserFavoriteModel], Error>()
        
        self.userFavoriteProductListener = userFavouriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else {
                print("[⚠️] Error: no data")
                return
            }
            let product: [UserFavoriteModel] = document.compactMap({ try? $0.data(as: UserFavoriteModel.self) })
            publisher.send(product)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    ///📌 Example 3 - Add listener -> all time when data will change in firestore it will be update immediately use - Publisher generic
    func addListenerFavoriteUserProductUseCustomPublisherGeneric(userId: String) -> AnyPublisher<[UserFavoriteModel], Error> {
        
        let (publisher, listener) = userFavouriteProductCollection(userId: userId)
            .addSnapshotListenerGeneric(as: UserFavoriteModel.self)
        
        self.userFavoriteProductListener = listener
        return publisher
    }
}

extension Query {
    
    ///📌 Generic for any type Listener
    func addSnapshotListenerGeneric<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, listener: ListenerRegistration) where T: Decodable {
        
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else {
                print("[⚠️] Error: no data")
                return
            }
            let product: [T] = document.compactMap({ try? $0.data(as: T.self) })
            publisher.send(product)
        }
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
}
