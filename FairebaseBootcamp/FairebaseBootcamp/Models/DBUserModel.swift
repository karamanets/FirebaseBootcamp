//
//  DBUserModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import Foundation

///🔥 userID must be not optional all else data make optional
struct DBUserModel {
    let userID: String
    let isAnon: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
}
