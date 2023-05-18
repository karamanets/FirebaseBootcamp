//
//  SignInView_Anon.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 16/05/2023.
//

import SwiftUI

struct SignInView_Anon: View {
    
    @ObservedObject var vm: SignInViewModel_Anon
    
    var body: some View {
            VStack {
                Button {
                    Task {
                        do {
                            try await vm.signInAnonymously()
                            withAnimation(.spring()) {
                                vm.isSignIn = true
                            }
                        } catch let error {
                            print("[⚠️] Error: \(error.localizedDescription)")
                        }
                    }
                } label: { buttonView }
            }
    }
}

struct SignInView_Anon_Previews: PreviewProvider {
    static var previews: some View {
        SignInView_Anon(vm: SignInViewModel_Anon())
    }
}

//MARK: Component
extension SignInView_Anon {
    
    /// Button View
    private var buttonView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.mint)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
            Text("Sign In")
                .foregroundColor(.white)
                .font(.system(size: 19))
        }
        .padding(.horizontal)
    }
}
