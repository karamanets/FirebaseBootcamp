//
//  CrashManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 01/06/2023.
//

import Foundation
import FirebaseCrashlytics

final class CrashManager {
    
    static let shared = CrashManager()
    
    private init() {}
    
    ///📌 Get user in Crashlytics - it may be sent in the start app when signIn
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
    
    ///📌 Set Key for Crashlytics
    private func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    ///📌 Set Key for user is Premium or not
    func setIsPremium(isPremium: Bool) {
        setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
    }
    
    ///📌 SetUp Log
    func addLog(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    ///📌 Send non fatal error
    func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
