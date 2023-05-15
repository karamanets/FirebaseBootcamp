//
//  Utility.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 13/05/2023.
//

import SwiftUI

final class Utility {
    
    static let shared = Utility()
    private init() {}
    
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

//MARK: Custom Errors
enum Errors: LocalizedError {
    case invalidCredential
    case invalidState
    case unableToFetchToken
    case unableToSerialiseToken
    case unableToFundNonce
    case vcExist
    
    var errorDescription: String? {
        switch self {
            
        case .invalidCredential:
            return "[⚠️] Invalid credential: ASAuthorization failure"
        case .invalidState:
            return "[⚠️] Invalid state: A login callback was received, but no login request was sent"
        case .unableToFetchToken:
            return "[⚠️] Unable to fetch identity token"
        case .unableToSerialiseToken:
            return "[⚠️] Unable to serialise token"
        case .unableToFundNonce:
            return "[⚠️] Unable to find current nonce"
        case .vcExist:
            return "[⚠️] Can't get top ViewController"
        }
    }
    
}
