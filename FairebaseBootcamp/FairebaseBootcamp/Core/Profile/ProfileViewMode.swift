//
//  ProfileViewMode.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 18/05/2023.
//

import Foundation

@MainActor
final class ProfileViewMode: ObservableObject {
    
    @Published private(set) var user: DBUserModel? = nil
    
    func loadCurrentUser() async throws {
        /// First get User id local
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        ///Second get user profile from firestore use local saved id
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
    }
    
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateFormat = formatter.string(from: date)
        
        return dateFormat
    }
}
