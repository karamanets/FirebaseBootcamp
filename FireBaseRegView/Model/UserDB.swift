//
//  UserDB.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 10.01.2023.
//

import Foundation


struct UserDB: Identifiable {
    
    var id: String
    var name: String
    var phone: String
    var address: String
    
    var representation: [String: Any] {
        
        var item = [String: Any]()
        item["id"] = self.id
        item["name"] = self.name
        item["phone"] = self.phone
        item["address"] = self.address
        
        return item
    }
}
