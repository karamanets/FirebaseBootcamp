//
//  HomeModel.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 05.01.2023.
//

import Foundation
import FirebaseAuth

class HomeViewModel: ObservableObject {
    
    @Published var user : User
    
    init(user: User) {
        self.user = user
    }
}
