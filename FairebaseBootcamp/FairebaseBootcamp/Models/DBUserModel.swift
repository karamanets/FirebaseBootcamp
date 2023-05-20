//
//  DBUserModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import Foundation

///🔥  Inside collection users, inside user document add custom type (map) with some data
struct Games: Codable {
    let id: String
    let name: String
    let top: Bool
}

///🔥 userID must be not optional all else data make optional
struct DBUserModel: Codable {
    let userId: String
    let isAnon: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    var isPremium: Bool?
    let preference: [String]?
    let game: Games? /// Add custom type
    
    ///📌 inject with Auth
    init(auth: AuthUserModel) {
        self.userId = auth.uid
        self.isAnon = auth.isAnon
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preference = nil
        self.game = nil
    }
    
    ///📌 init with user ID
    init(
    userId: String,
    isAnon: Bool? = nil,
    email: String? = nil,
    photoUrl: String? = nil,
    dateCreated: Date? = nil,
    isPremium: Bool? = nil,
    preference: [String]? = nil,
    game: Games? = nil
    ) {
        self.userId = userId
        self.isAnon = isAnon
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preference = preference
        self.game = game
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
        case preference = "preference"
        case game = "game"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnon = try container.decodeIfPresent(Bool.self, forKey: .isAnon)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preference = try container.decodeIfPresent([String].self, forKey: .preference)
        self.game = try container.decodeIfPresent(Games.self, forKey: .game)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnon, forKey: .isAnon)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preference, forKey: .preference)
        try container.encodeIfPresent(self.game, forKey: .game)
    }
}
