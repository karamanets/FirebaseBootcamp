//
//  GoogleSignInModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 12/05/2023.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInModel {
    let idToken: String
    let accessToken: String
}

final class GoogleSignInHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInModel {
        /// Get top viewController
        guard let topVC = Utility.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
            
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        /// Have extra data
        //let userName = signInResult.user.profile?.name
        //let userSecondName = signInResult.user.profile?.familyName
        //let userEmail = signInResult.user.profile?.email
        
        guard let idToken = signInResult.user.idToken?.tokenString else {
            throw URLError(.cannotFindHost)
        }
        
        let accessToken = signInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInModel(idToken: idToken, accessToken: accessToken)
        
        return tokens
    }
}
