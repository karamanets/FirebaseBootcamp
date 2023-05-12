//
//  GoogleSignInView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 12/05/2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignIn: View {
    
    @StateObject private var vm = GoogleViewModel()
    
    var body: some View {
        
        VStack {
            
            GoogleSignInButton(scheme: .light, style: .standard, state: .normal) {
                Task {
                    do {
                        try await vm.signInGoogle()
                        ///show view
                    } catch let error {
                        print("[⚠️] Error: \(error.localizedDescription)")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

//                     🔱
struct GoogleSignInView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignIn()
    }
}
