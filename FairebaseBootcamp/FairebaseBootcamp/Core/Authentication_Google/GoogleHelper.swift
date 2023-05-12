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
        guard let topVC = topViewController() else {
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
    
    /// UiKit component - get top viewController 
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}
