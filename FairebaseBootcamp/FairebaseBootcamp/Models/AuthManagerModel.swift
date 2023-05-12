//
//  Models.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 12/05/2023.
//

import Foundation
import Firebase

//MARK: - 🔥 Model
struct AuthManagerModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        
        ///user.isAnonymous
        ///user.phoneNumber
        ///...
    }
}
