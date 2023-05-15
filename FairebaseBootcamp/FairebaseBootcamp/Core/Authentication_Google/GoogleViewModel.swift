//
//  GoogleViewModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 12/05/2023.
//

import Foundation

//Add
//1) GIDClientID -> from CLIENT_ID in GoogleService-Info
//2) URL Types URL Schemes id from -> REVERSED_CLIENT_ID in GoogleService-Info

@MainActor
final class GoogleViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = GoogleSignInHelper()
        let token = try await helper.signIn()
        try await AuthManager.shared.signInWithGoogle(tokens: token)
    }
}
