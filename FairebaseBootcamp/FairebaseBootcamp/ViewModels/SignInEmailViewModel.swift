//
//  SignInEmailViewModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email  = ""
    @Published var password = ""
    @Published var alert = false
    @Published var alertMessage = ""
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        Task {
            do {
                let returnResult = try await AuthManagerEmail.shared.createUser(email: email, password: password)
                alert.toggle()
                alertMessage = "[🔥] Success user: \(returnResult)"
            } catch {
                alert.toggle()
                alertMessage = "[🔥] Error"
            }
        }
    }
    
}
