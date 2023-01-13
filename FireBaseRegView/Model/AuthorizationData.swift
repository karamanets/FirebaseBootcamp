//
//  Authorization.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 06.01.2023.
//

import Foundation

class AuthorizationModel: ObservableObject {
    
    
    @Published var showHome = false {
        
        didSet {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(showHome) {
                UserDefaults.standard.set(data, forKey: "HomeView")
            }
        }
    }
    
    init() {
        if let item = UserDefaults.standard.data(forKey: "HomeView") {
            
            let decoder = JSONDecoder()
            
            if let data = try? decoder.decode(Bool.self, from: item) {
                self.showHome = data
            }
        }
    }
}
