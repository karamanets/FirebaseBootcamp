//
//  Models.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 12/05/2023.
//

import Foundation
import Firebase

//MARK: - 🔥 Model







struct AuthUserModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnon: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnon = user.isAnonymous
        
        ///user.isAnonymous
        ///user.phoneNumber
        ///...
    }
}








