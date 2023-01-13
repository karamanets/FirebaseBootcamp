//
//  HomeViewModel.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 12.01.2023.
//

import Foundation

class UserDBViewModel: ObservableObject { // profileViewModel!
    
    @Published var userDB: UserDB
    @Published var someRandomImage = URL(string: "https://picsum.photos/400")
    
    init(UserDB: UserDB) {
        self.userDB = UserDB
    }
    
    func setProfile() {
        
        DataBaseService.shared.setProfile(user: self.userDB) { result in
            switch result {
            case .success(let result):
                print(result.name)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func getProfile() {
        
        DataBaseService.shared.getProfile { result in
            switch result {
                
            case .success(let user):
                self.userDB = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
