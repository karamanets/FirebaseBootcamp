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
    
    ///📌 Load user document (portfolio) from users Collection
    func loadCurrentUser() async throws {
        /// First get User id local
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        
        ///Second get user profile from firestore use local saved id  (codable protocol)
        self.user = try await UserManager.shared.getUser(user: authDataResult.uid)
    }
    
    ///📌 Convert data into String
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        let dateFormat = formatter.string(from: date)
        
        return dateFormat
    }
    
    ///📌 Update data isPremium use merge all data
    func toggleIsPremium() {
        guard var user else { return }
        user.toggleIsPremium()
        
        Task {
            try await UserManager.shared.updateUserIsPremiumStatus(user: user)
            self.user = try await UserManager.shared.getUser(user: user.userId)
        }
    }
    
    ///📌 Update data isPremium use Single value
    func toggleIsPremium2() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        
        Task {
            try await UserManager.shared.updateUserIsPremiumStatusSingle(userId: user.userId, isPremium: !currentValue )
            self.user = try await UserManager.shared.getUser(user: user.userId)
        }
    }
    
}
