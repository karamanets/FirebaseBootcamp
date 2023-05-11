//
//  SignInEmail.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import Foundation


@MainActor
final class SignInEmail: ObservableObject {
    
    @Published var email  = ""
    @Published var password = ""
    @Published var alert = false
    @Published var alertMessage = ""
    @Published var isSignIn = false
    @Published var user: AuthManagerEmailModel? = nil
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        Task {
            do {
                let returnResult = try await AuthManagerEmail.shared.createUser(email: email, password: password)
                user = returnResult
                alert.toggle()
                alertMessage = "[🔥] Success user email is: \(returnResult.email ?? "")"
                
            } catch {
                alert.toggle()
                alertMessage = "[🔥] Error"
            }
        }
    }
    
    func logOut() throws {
        try AuthManagerEmail.shared.signOut()
    }

    func isUserExist() throws -> AuthManagerEmailModel {
        let user = try AuthManagerEmail.shared.getAuthenticatedUser()
        return user
    }
    
}
