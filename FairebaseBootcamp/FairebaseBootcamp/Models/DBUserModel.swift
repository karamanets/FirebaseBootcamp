//
//  DBUserModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import Foundation

///🔥 userID must be not optional all else data make optional
struct DBUserModel: Codable {
    let userId: String
    let isAnon: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    var isPremium: Bool?
    
    ///📌 inject auth
    init(auth: AuthUserModel) {
        self.userId = auth.uid
        self.isAnon = auth.isAnon
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
    }
    
    ///📌 init for marge data with userId
    init(
    userId: String,
    isAnon: Bool? = nil,
    email: String? = nil,
    photoUrl: String? = nil,
    dateCreated: Date? = nil,
    isPremium: Bool? = nil
    ) {
        self.userId = userId
        self.isAnon = isAnon
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
    
    //MARK: Methods
    
    ///📌 Toggle isPremium value use mutating in model
    mutating func toggleIsPremium() {
        let currentValue = isPremium ?? false
        isPremium = !currentValue
    }
    
    //MARK: - Instead using decoder and encoder in UserManager - can use it
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnon = "is_anon"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnon, forKey: .isAnon)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnon = try container.decodeIfPresent(Bool.self, forKey: .isAnon)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
}
