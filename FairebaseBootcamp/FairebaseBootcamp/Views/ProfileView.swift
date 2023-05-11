//
//  SomeView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var vm: SignInEmail
    
    var body: some View {
            VStack {
                Button {
                    Task {
                        do {
                            try vm.logOut()
                            withAnimation(.spring()) {
                                vm.isSignIn = false
                            }
                        } catch {
                            print("[⚠️] Error logOut")
                        }
                    }
                } label: {
                    Text("SignOut")
                }
                .buttonMode()
            }
    }
}

//               🔱
struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(vm: SignInEmail())
        }
    }
}

